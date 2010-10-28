class Merch < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	has_many :orders
	
  	has_attached_file :artwork, :default_url => "/images/:class/:attachment/missing_:style.jpg",
		:styles => {
			:tiny  => "40x60",
			:thumb => "80x120",
			:reg => "185x280"
		}

end
