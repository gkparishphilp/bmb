# == Schema Information
# Schema version: 20101103181324
#
# Table name: assets
#
#  id                  :integer(4)      not null, primary key
#  book_id             :integer(4)
#  content_location_id :integer(4)
#  name                :string(255)
#  format              :string(255)
#  price               :integer(4)
#  download_count      :integer(4)      default(0)
#  asset_type          :string(255)
#  word_count          :integer(4)
#  origin              :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Asset < ActiveRecord::Base
	# represents a book's 'product'
	# the digital assets we have for a book
	# may be the full work in some digital format
	# or a sample, or a bonus, or a giveaway, etc.
	
	belongs_to	:book
	has_one	 	:content_location
	
	def content
		# Alias this to the actual content of the asset
		unless self.content_location.path.blank?
			# send the contents of the file referred to by the path
		else
			# return the contents of the content_location.content DB field
			return self.content_location.content
		end
	end
	
end
