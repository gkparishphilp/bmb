class Book < ActiveRecord::Base
	# todo -- stub book model
	# represents a "title" or "work"
	
	belongs_to	:author
	belongs_to  :genre
	
	has_many	:assets
	has_many	:book_identifiers
	# todo -- add links
	#has_many	:links, :as => :owner
	has_many	:reviews, :as => :reviewable
	has_many	:readings
	has_many	:readers, :through => :readings, :source => :user
	has_one		:upload_file
	
	has_friendly_id			:title, :use_slug => :true
	acts_as_taggable_on		:tags
end
