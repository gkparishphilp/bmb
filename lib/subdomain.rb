class Subdomain
	# this is a constraint validator on the subdomain route
	def self.matches?( request )
		request.subdomain.present? && !APP_SUBDOMAINS.include?( request.subdomain )
	end
end