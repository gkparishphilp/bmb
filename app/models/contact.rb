# == Schema Information
# Schema version: 20101110044151
#
# Table name: contacts
#
#  id         :integer(4)      not null, primary key
#  site_id    :integer(4)
#  email      :string(255)
#  subject    :string(255)
#  ip         :string(255)
#  crash_id   :integer(4)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Contact < ActiveRecord::Base
                        
    validates_presence_of :subject, :message => "Please provide a subject"

	belongs_to	:crash
    
end
