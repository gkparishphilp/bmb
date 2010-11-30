# == Schema Information
# Schema version: 20101120000321
#
# Table name: book_identifiers
#
#  id              :integer(4)      not null, primary key
#  book_id         :integer(4)
#  identifier_type :string(255)
#  identifier      :string(255)
#  status          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class BookIdentifier < ActiveRecord::Base
	#Global ID for books.  ISBNs, ASINs, etc.
	
	belongs_to	:book
	
end
