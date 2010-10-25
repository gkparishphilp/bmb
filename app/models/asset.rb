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
		else
	end
	
end
