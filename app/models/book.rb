# == Schema Information
# Schema version: 20101103181324
#
# Table name: books
#
#  id                     :integer(4)      not null, primary key
#  title                  :string(255)
#  author_id              :integer(4)
#  genre_id               :integer(4)
#  view_count             :integer(4)      default(0)
#  score                  :integer(4)
#  subtitle               :string(255)
#  description            :text
#  status                 :string(255)
#  age_aprop              :string(255)
#  rating_average         :float
#  backing_url            :string(255)
#  cached_slug            :string(255)
#  cover_art_url          :string(255)
#  cover_art_file_name    :string(255)
#  cover_art_content_type :string(255)
#  cover_art_file_size    :integer(4)
#  cover_art_updated_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#

class Book < ActiveRecord::Base
	# represents a "title" or "work"
	
	belongs_to	:author
	belongs_to  :genre
	
	has_many	:assets
	has_many	:book_identifiers
	# todo -- add links
	has_many	:links, :as => :owner
	has_many	:reviews, :as => :reviewable
	has_many	:readings
	has_many	:readers, :through => :readings, :source => :user
	has_one		:upload_file
	
	has_friendly_id			:title, :use_slug => :true
	acts_as_taggable_on		:tags
end
