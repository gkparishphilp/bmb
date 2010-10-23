class StaticPage < ActiveRecord::Base
	before_create 	:set_description
	before_save		:clean_permalink
    
	validate    			:valid_permalink?


	def self.invalid_permalinks
		invalid_words = APP_ROUTE_PATHS.map { |route| route.path.to_s.match( /\w+\W/ ).to_s.chop }.uniq
		invalid_words += StaticPage.select(:permalink).map { |p| p.permalink }
	end
	
protected 
	def set_description
		self.description = self.content[0..200] if self.description.blank?
	end

	def clean_permalink
		self.permalink.gsub!(/\W/, "-")
	end
    
private
	def valid_permalink?
		if StaticPage.invalid_permalinks.include?( permalink )
			errors.add( :permalink, "Conflicts with existing routes." )
		end
	end
end