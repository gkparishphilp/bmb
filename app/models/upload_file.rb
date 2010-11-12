# == Schema Information
# Schema version: 20101110044151
#
# Table name: upload_files
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  book_id    :integer(4)
#  title      :string(255)
#  ext        :string(255)
#  file_path  :string(255)
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class UploadFile < ActiveRecord::Base
	
	# todo -- need to rewrite to accept file uploads, process them, and create appropriate asset entries
		
	belongs_to	:user
	belongs_to	:book

	
end
