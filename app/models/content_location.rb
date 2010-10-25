class ContentLocation < ActiveRecord::Base
	# Gives you the actual content for an asset 
	# The content may be on the filesystem (accessed via a path)
	# or in a longtext DB field on this object
	belongs_to	:asset
	
end