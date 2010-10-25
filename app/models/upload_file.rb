class UploadFile < ActiveRecord::Base
	
	# todo -- need to rewrite to accept file uploads, process them, and create appropriate asset entries
		
	belongs_to	:user
	belongs_to	:book

	
end
