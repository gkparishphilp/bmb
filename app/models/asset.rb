# == Schema Information
# Schema version: 20101110044151
#
# Table name: assets
#
#  id             :integer(4)      not null, primary key
#  book_id        :integer(4)
#  title          :string(255)
#  format         :string(255)
#  price          :integer(4)
#  download_count :integer(4)      default(0)
#  asset_type     :string(255)
#  content        :text(2147483647
#  word_count     :integer(4)
#  origin         :string(255)
#  status         :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Asset < ActiveRecord::Base
	# represents a book's 'product'
	# the digital assets we have for a book
	# may be the full work in some digital format
	# or a sample, or a bonus, or a giveaway, etc.

	has_many	:coupons, :as => :redeemable
	has_many	:orders, :as  => :ordered
	belongs_to	:book
	belongs_to	:bundle_asset
	has_many	:owners, :through => :ownings
	
	has_attached :content_file, :formats => ['html', 'doc', 'txt', 'rtf', 'epub', 'mobi', 'pdf', 'mp3', 'aac', 'docx', 'odt', 'ogg', 'wav', 'htm'], :private => true
	
	def content
		# Alias this to the actual content of the asset
		unless self.content_location.path.blank?
			# send the contents of the file referred to by the path
		else
			# return the contents of the content_location.content DB field
			return self.content_location.content
		end
	end
	
	def add_to_bundle(bundle)
		BundleAsset.create!( :bundle_id => bundle.id, :asset_id => self.id )	
	end
	
end
