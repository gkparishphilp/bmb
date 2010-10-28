# == Schema Information
# Schema version: 20101026212141
#
# Table name: merches
#
#  id                   :integer(4)      not null, primary key
#  owner                :integer(4)
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
#  created_at           :datetime
#  updated_at           :datetime
#

class Merch < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	has_many :orders, :as => :ordered
	
  	has_attached_file :artwork, :default_url => "/images/:class/:attachment/missing_:style.jpg",
		:styles => {
			:tiny  => "40x60",
			:thumb => "80x120",
			:reg => "185x280"
		}

end
