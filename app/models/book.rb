# t.string   "title"
# t.integer  "author_id"
# t.integer  "genre_id"
# t.integer  "view_count", default => 0
# t.integer  "score"
# t.string   "subtitle"
# t.text     "description"
# t.string   "status"
# t.string   "age_aprop"
# t.float    "rating_average"
# t.string   "backing_url"
# t.string   "cached_slug"
# t.string   "cover_art_url"
# t.string   "cover_art_file_name"
# t.string   "cover_art_content_type"
# t.integer  "cover_art_file_size"
# t.datetime "cover_art_updated_at"
# t.datetime "created_at"
# t.datetime "updated_at"

class Book < ActiveRecord::Base
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
