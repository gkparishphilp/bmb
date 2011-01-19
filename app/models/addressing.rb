# == Schema Information
# Schema version: 20110105172220
#
# Table name: addressings
#
#  id             :integer(4)      not null, primary key
#  owner_id       :integer(4)
#  owner_type     :string(255)
#  geo_address_id :integer(4)
#  address_type   :string(255)
#  preferred      :boolean(1)
#

class Addressing < ActiveRecord::Base
	# a join table between address owners and addresses
	
	belongs_to	:owner, :polymorphic => true
	belongs_to	:geo_address
	
	accepts_nested_attributes_for	:geo_address
	
	scope :billing, where( " address_type = 'billing' " )
	scope :shipping, where( " address_type = 'shipping' " )
	scope :nexus, where( " address_type = 'nexus' " ) # royalty payee's address for calculating tax, widtholdings, etc.
	
end
