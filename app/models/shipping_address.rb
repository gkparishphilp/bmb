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