class Owning < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
	belongs_to :owned, :polymorphic => true
end
