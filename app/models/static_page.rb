class StaticPage < ActiveRecord::Base
	before_create 	:set_description
	before_save		:clean_permalink
    
	validates_uniqueness_of	:permalink
	validate    			:valid_permalink?

protected 
	def set_description
		self.description = self.content[0..200] if self.description.blank?
	end

	def clean_permalink
		self.permalink.gsub!(/\W/, "-")
	end
    
private
	def valid_permalink?
		@invalid_words = ActionController::Routing.possible_controllers
		@invalid_words += ['index', 'logout']
		if @invalid_words.include?( permalink )
			errors.add( :permalink, "Conflicts with existing routes." )
		end
	end
end