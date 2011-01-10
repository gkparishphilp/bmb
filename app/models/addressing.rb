class Addressing < ActiveRecord::Base
	# a join table between address owners and addresses
	belongs_to	:owner, :polymorphic => true
	belongs_to	:geo_address
	
	scope :billing, where( " address_type = 'billing' " )
	scope :shipping, where( " address_type = 'shipping' " )
	scope :nexus, where( " address_type = 'nexus' " ) # royalty payee's address for calculating tax, widtholdings, etc.
	
end