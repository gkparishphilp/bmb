# == Schema Information
# Schema version: 20110104222559
#
# Table name: geo_addresses
#
#  id           :integer(4)      not null, primary key
#  address_type :string(255)
#  user_id      :integer(4)
#  title        :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  street       :string(255)
#  street2      :string(255)
#  city         :string(255)
#  geo_state_id :integer(4)
#  zip          :string(255)
#  country      :string(255)
#  phone        :string(255)
#  preferred    :boolean(1)
#  created_at   :datetime
#  updated_at   :datetime
#


# TODO - delete this
class ShippingAddress < GeoAddress
	belongs_to :user
	has_many :orders
	belongs_to :geo_state
	
	validates :first_name, :presence => true
	validates :last_name, :presence => true
	validates :street, :presence => true
	validates :city, :presence => true
	validates :geo_state_id, :presence => true
	validates :zip, :presence => true
	validates :country, :presence => true
end
