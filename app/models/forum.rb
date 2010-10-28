# == Schema Information
# Schema version: 20101026212141
#
# Table name: forums
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  owner_id     :integer(4)
#  owner_type   :string(255)
#  availability :string(255)
#  description  :string(255)
#  cached_slug  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Forum < ActiveRecord::Base
	has_many    :topics
	has_many    :posts
    
	has_friendly_id :name, :use_slug => :true
	
end
