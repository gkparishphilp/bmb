class ApplicationController < ActionController::Base
	protect_from_forgery



	protected
	
	def pop_flash( message, code = :success, *object )
		flash[code] = message
		
		object.each do |obj|
			obj.errors.each do |field, msg|
				flash[code] += "<br>" + field + ": " if field
				flash[code] += " " + msg 
			end
		end
		
	end
	
	def set_meta( title, *description )
		@title = title
		@description = description.first[0..200] unless description.first.blank?
	end
	
end
