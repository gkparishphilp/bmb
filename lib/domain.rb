class Domain
	# this is a constraint validator on the domain route
	def self.matches?( request )
		not APP_DOMAINS.include? request.domain
	end
end