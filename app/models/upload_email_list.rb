# == Schema Information
# Schema version: 20110826004210
#
# Table name: upload_email_lists
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  owner_type :string(255)
#  file_name  :string(255)
#  file_path  :string(255)
#  list_type  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UploadEmailList < ActiveRecord::Base
	# Created attr_accessor for book_id so select box would work on form for giveaways
	require 'csv'
	attr_accessor :sku_id
	after_save :process_file
	belongs_to :author
	
	protected
	
	def process_file
		directory = "#{Rails.root}/assets/email_lists"
		save_filename = self.file_path
		path = File.join( directory, save_filename)
		
		File.open(path, "wb") {|f| f.write( self.file_name.read) }

		if self.list_type == 'giveaway'
			process_giveaway_list(path)
		elsif self.list_type == 'newsletter'
			process_newsletter_list(path)
		end
		
		#FileUtils.rm_r( path ) if File.exists?( path )
	end
	
		
	def process_giveaway_list(path)
		CSV.foreach( path ) do |row|
			sku = Sku.find(sku_id)	
			email = row[0]  # TODO better validation on email address
			user = User.find_or_initialize_by_email( :email=> email )
			user.save( false )					

			next if user.coupons.find_by_sku_id( sku.id)
			coupon = Coupon.new
			coupon.generate_code
			coupon.update_attributes! :owner => self.author, :sku => sku, :user => user, :redemptions_allowed => 1, :discount_type => 'percent', :discount => 100
		end
	end


	def process_newsletter_list(path)
		CSV.foreach( path ) do |row|
			name = row[0]
			email = row[1]
			if email.match(/^[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z_+])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9}$/) 
				name = email.gsub(/\W/, "_") if name.blank?
				user = User.find_or_initialize_by_email( :email => email)
				user.name = name.encode('utf-8') rescue user.name = email.gsub(/\W/, "_")
				user.save
				if self.author
					subscribing = EmailSubscribing.find_or_create_subscription( self.author, user)
				end
			end
		end
	end
		
end
