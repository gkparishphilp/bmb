# == Schema Information
# Schema version: 20110121210536
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
	
	acts_as_tree :order => 'name'

end
