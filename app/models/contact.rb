class Contact < ActiveRecord::Base
                        
    validates_presence_of :subject, :message => "Please provide a subject"

	belongs_to	:crash
    
end