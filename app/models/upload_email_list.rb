class UploadEmailList < ActiveRecord::Base
	# Created attr_accessor for book_id so select box would work on form for giveaways
	require 'csv'
	attr_accessor :book_id
	after_save :process_file
	belongs_to :author
	
	protected
	
	def process_file
		directory = "#{Rails.root}/assets/email_lists"
		save_filename = self.file_path
		path = File.join( directory, save_filename)
		redeemable = Book.find(book_id)		
		File.open(path, "wb") {|f| f.write( self.file_name.read) }

		CSV.foreach( path ) do |row|
			if self.list_type == 'giveaway'
				email = row[0]  # TODO better validation on email address
				user = User.find_or_initialize_by_email( :email=> email )
				user.save( false )					

				next if user.coupons.find_by_redeemable_type_and_redeemable_id( redeemable.class, redeemable.id)

				coupon = Coupon.new
				coupon.generate_giveaway_code
				coupon.update_attributes! :owner => self.author, :redeemable => redeemable, :redeemer => user, :redemptions_allowed => 1

			else
				#Assume its an email subscription list	
				name = row[0]
				email = row[1]
				if self.author
					next if EmailSubscription.find_by_author_id_and_email( self.author.id, email )
					EmailSubscription.create( :author_id => self.author.id, :name =>name, :email => email, :source => "Imported " + self.created_at.to_s(:long) ) 
				else
					next if EmailSubscription.find_by_email( email )
					EmailSubscription.create( :name =>name, :email => email, :source => "Imported " + self.created_at.to_s(:long)  ) 
				end
			end
			 

		end
			
		#FileUtils.rm_r( path ) if File.exists?( path )

	end
	


	
end
