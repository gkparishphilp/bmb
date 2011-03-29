# == Schema Information
# Schema version: 20110327221930
#
# Table name: contacts
#
#  id          :integer(4)      not null, primary key
#  site_id     :integer(4)
#  email       :string(255)
#  subject     :string(255)
#  ip          :string(255)
#  crash_id    :integer(4)
#  content     :text
#  created_at  :datetime
#  updated_at  :datetime
#  author_id   :integer(4)
#  user_id     :integer(4)
#  phone       :string(255)
#  web_address :string(255)
#  referrer    :string(255)
#

class Contact < ActiveRecord::Base
                        
    validates_presence_of :subject, :message => "Please provide a subject"
	validates_presence_of :email
	
	belongs_to	:user
	belongs_to	:author
	belongs_to	:site
    
end
