# == Schema Information
# Schema version: 20101120000321
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  owner_type  :string(255)
#  title       :string(255)
#  description :text
#  starts_at   :datetime
#  ends_at     :datetime
#  location    :string(255)
#  event_type  :string(255)
#  status      :string(255)     default("publish")
#  created_at  :datetime
#  updated_at  :datetime
#

class Event < ActiveRecord::Base
	
	belongs_to :owner, :polymorphic => true
    
	has_friendly_id :title, :use_slug => :true
	
	scope :published, where( "ends_at <= ? and status = 'publish'", Time.now )
		
	scope :upcomming, lambda { |*args|
		limit( args.first || 5 )
		order( 'starts_at desc' )
	}
	
	scope :dated_between, lambda { |*args| 
		where( "starts_at between ? and ?", (args.first || 1.day.ago), (args.second || Time.now) ) 
	} 
	
	scope :month_year, lambda { |*args| 
		where( " month(starts_at) = ? and year(starts_at) = ?", (args.first || Time.now.month), (args.second || Time.now.year) )
		order( 'starts_at desc' )
	}
	
	scope :year, lambda { |*args| 
		where( " year(starts_at) = ?", (args.first || Time.now.year) )
		order( 'starts_at desc' )
	}
	
	
	def published?
		self.ends_at <= Time.now && self.status == 'publish'
	end
	
end
