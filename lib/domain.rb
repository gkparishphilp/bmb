class Domain
	# this is a constraint validator on the domain route
	def self.matches?( request )
		request.domain != "localhost"
	end
end