class EmailTemplate < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	scope :shipping, where("template_type = 'shipping'")
end
