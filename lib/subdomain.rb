class Subdomain
	def self.matches?( request )
		request.subdomain.present? && !APP_SUBDOMAINS.include?( request.subdomain )
	end
end