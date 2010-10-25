class Author < ActiveRecord::Base
	# todo -- stub author model
	# represents writer of a book
	# may or may not belong to user
	
	has_many	:books
	
	belongs_to	:user
	
	has_friendly_id	:pen_name, :use_slug => true
end
