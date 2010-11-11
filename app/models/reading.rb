# == Schema Information
# Schema version: 20101110044151
#
# Table name: readings
#
#  id           :integer(4)      not null, primary key
#  book_id      :integer(4)
#  user_id      :integer(4)
#  page_number  :integer(4)
#  reading_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Reading < ActiveRecord::Base
	# For when a user has 'interacted' with a book
	# may be read sample, download, read online, etc..
	
	belongs_to	:user
	belongs_to	:book

end
