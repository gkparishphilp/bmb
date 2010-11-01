class BillingAddress < GeoAddress
	belongs_to :user
	has_many :orders
	belongs_to :geo_state
end
