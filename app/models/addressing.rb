class Addressing < ActiveRecord::Base
	# a join table between address owners and addresses
	belongs_to	:owner, :polymorphic => true
	belongs_to	:geo_address
end