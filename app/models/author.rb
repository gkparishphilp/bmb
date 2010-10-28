# == Schema Information
# Schema version: 20101026212141
#
# Table name: authors
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  featured_book_id   :integer(4)
#  pen_name           :string(255)
#  subdomain          :string(255)
#  domain             :string(255)
#  bio                :text
#  score              :integer(4)
#  cached_slug        :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  photo_url          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Author < ActiveRecord::Base
<<<<<<< HEAD:app/models/author.rb

	# authors table
	# t.integer	:user_id
	# t.integer	:featured_book_id
	# t.string	:pen_name
	# t.text		:bio
	# t.integer	:score
	# t.string	:cached_slug
	# t.string	:photo_file_name
	# t.string	:photo_content_type
	# t.integer	:photo_file_size
	# t.datetime	:photo_updated_at
	# t.string	:photo_url
	#	t.timestamps

	# todo -- stub author model
=======
>>>>>>> master:app/models/author.rb
	# represents writer of a book
	# may or may not belong to user
	
	
	has_many	:books
	
	belongs_to	:user
	
	has_friendly_id	:pen_name, :use_slug => true
	
	has_many :merches, :as  => :owner
	
end
