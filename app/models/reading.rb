class Reading < ActiveRecord::Base
	# For when a user has 'interacted' with a book
	# may be read sample, download, read online, etc..
	
	belongs_to	:user
	belongs_to	:book

end