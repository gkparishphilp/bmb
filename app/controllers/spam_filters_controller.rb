class SpamFiltersController < ApplicationController
	
	def add_ip
		unless SpamFilter.find_by_filter_type_and_filter_value( 'ip', params[:value])
			SpamFilter.create( :filter_type => 'ip', :filter_value => params[:value], :filter_action => 'spam' )
			pop_flash "IP address added to spam filter", :success
		end
		redirect_to :back
	end
	
	def add_keyword
		unless SpamFilter.find_by_filter_type_and_filter_value( 'keyword', params[:value])
			SpamFilter.create( :filter_type => 'keyword', :filter_value => params[:value], :filter_action => 'spam' )
			pop_flash "Keyword added to spam filter", :success
			
		end
		redirect_to :back
		
	end
	
	def add_email
		email = params[:value]
		strip_email = email.gsub(/\./,"")
		unless SpamFilter.find_by_filter_type_and_filter_value( 'email', strip_email)
			SpamFilter.create( :filter_type => 'email', :filter_value => strip_email, :filter_action => 'spam' )
			pop_flash "Email added to spam filter", :success
		end
		redirect_to :back
	end
end
