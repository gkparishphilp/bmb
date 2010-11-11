# == Schema Information
# Schema version: 20101110044151
#
# Table name: genres
#
#  id          :integer(4)      not null, primary key
#  parent_id   :integer(4)
#  name        :string(255)
#  description :string(255)
#  cached_slug :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Genre < ActiveRecord::Base

    has_many    :books

	has_friendly_id :name, :use_slug => :true
	
	# todo -- add acts_as_tree plugin and uncomment 
	#acts_as_tree :order => 'name'

	def self.top( *num )
		if num
			num -= 1
		else
			num = 9
		end
		top = self.all.sort { |a,b| b.books.count <=> a.books.count }
		top = top[0..num]
	end

	def all_books
		books = self.books
		for genre in self.children
			books += genre.books unless genre.books.empty?
		end
		
		return books
		
	end
end
