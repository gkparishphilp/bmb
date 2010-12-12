module GhettoSearchable #:nodoc:
	module Searchable

		def self.included( base )
			base.extend ClassMethods
		end

		module ClassMethods
			
			def searchable_on( field )
				self.class_eval do
					def self.search( term )
						if term.present?
							where( "name like ? ", "%#{term}%" )
						else
							return scoped
						end
					end
				end	
			end
			
		end
	end
end