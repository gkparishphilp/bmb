# == Schema Information
# Schema version: 20101110044151
#
# Table name: merches
#
#  id                   :integer(4)      not null, primary key
#  owner_id             :integer(4)
#  owner_type           :string(255)
#  title                :string(255)
#  description          :text
#  inventory_count      :integer(4)      default(-1)
#  price                :integer(4)
#  artwork_url          :string(255)
#  artwork_file_name    :string(255)
#  artwork_content_type :string(255)
#  artwork_file_size    :integer(4)
#  artwork_updated_at   :datetime
#  status               :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class Merch < ActiveRecord::Base
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to :owner, :polymorphic => true
	has_many :owners, :through => :ownings
	has_many :orders, :as => :ordered
	has_many :coupons, :as => :redeemable
	
	
  	has_attached_file :artwork, :default_url => "/images/:class/:attachment/missing_:style.jpg",
		:styles => {
			:tiny  => "40x60",
			:thumb => "80x120",
			:reg => "185x280"
		}

end
