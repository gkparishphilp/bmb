class Faq < ActiveRecord::Base
	
	belongs_to :author
	
	searchable_on	[ :title ]
end