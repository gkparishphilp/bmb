class BookIdentifier < ActiveRecord::Base
	#Global ID for books.  ISBNs, ASINs, etc.
	
	belongs_to	:book
	
end