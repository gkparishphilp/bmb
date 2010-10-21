class Forum < ActiveRecord::Base
	has_many    :topics
	has_many    :posts
    
	has_friendly_id :name, :use_slug => :true
	
end