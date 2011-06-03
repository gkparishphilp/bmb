# == Schema Information
# Schema version: 20110602204757
#
# Table name: email_templates
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(4)
#  owner_type    :string(255)
#  subject       :string(255)
#  content       :text
#  description   :string(255)
#  template_type :string(255)
#

class EmailTemplate < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	scope :shipping, where("template_type = 'shipping'")
	scope :inventory_warning, where("template_type = 'inventory_warning'")
	scope :refund, where("template_type = 'refund'")
end
