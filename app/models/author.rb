# t.integer  "user_id"
# t.integer  "featured_book_id"
# t.string   "pen_name"
# t.string   "subdomain"
# t.string   "domain"
# t.text     "bio"
# t.integer  "score"
# t.string   "cached_slug"
# t.string   "photo_file_name"
# t.string   "photo_content_type"
# t.integer  "photo_file_size"
# t.datetime "photo_updated_at"
# t.string   "photo_url"
# t.datetime "created_at"
# t.datetime "updated_at"

class Author < ActiveRecord::Base
	# represents writer of a book
	# may or may not belong to user
	
	has_many	:books
	
	belongs_to	:user
	
	has_friendly_id	:pen_name, :use_slug => true
end
