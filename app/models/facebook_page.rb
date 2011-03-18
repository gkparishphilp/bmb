# == Schema Information
# Schema version: 20110318174450
#
# Table name: facebook_pages
#
#  id                  :integer(4)      not null, primary key
#  facebook_account_id :integer(4)
#  name                :string(255)
#  page_type           :string(255)
#  fb_id               :string(255)
#  status              :string(255)     default("active")
#  created_at          :datetime
#  updated_at          :datetime
#


class FacebookPage < ActiveRecord::Base
	
	belongs_to  :facebook_account
	
end
