# == Schema Information
# Schema version: 20101103181324
#
# Table name: authors
#
#  id                 :integer(4)      not null, primary key
#  user_id            :integer(4)
#  featured_book_id   :integer(4)
#  pen_name           :string(255)
#  subdomain          :string(255)
#  domain             :string(255)
#  bio                :text
#  score              :integer(4)
#  cached_slug        :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  photo_url          :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Author < ActiveRecord::Base
	# represents writer of a book
	# may or may not belong to user
	
	after_create	:create_default_campaign
	
	has_many	:books
	belongs_to	:user
	
	has_friendly_id	:pen_name, :use_slug => true
	
	has_many	 :merches, :as  => :owner
	has_many	 :royalties
	has_many	 :upload_email_lists
	has_many	 :coupons, :as => :owner
	has_many 	:coupons, :as => :redeemer
	has_many 	:redemptions, :as => :redeemer
	has_many	:email_subscribings, :as => :subscribed_to # This will list the author's subscribers, not what the author is subscribed to!
	has_many	:email_campaigns, :as => :owner
	
	
	def create_default_campaign
		EmailCampaign.create!(:owner_type => self.class, :owner_id => self.id, :title => 'Default')
	end
	
end
