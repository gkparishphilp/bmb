class RecommendsController < ApplicationController
    def show
        @book = Book.find params[:id]
        @user = User.find params[:user_id]
		
		# if on this in the future...
        
		b = Backing.find_or_create_by_user_id_and_book_id :user_id => @user.id, :book_id => @book.id

		#raw_ev = b.raw_backing_events.create :ip => request.ip, :url => request.env['HTTP_REFERER'], :event_type => 'referral', :points => REFERRAL_POINTS
		
		#raw_ev.process
		
		cookies[:backer] = { :value => @user.id, :expires => 7.days.from_now }
		pop_flashflash = "#{@user.user_name} recommended '#{@book.title}'.  Hope you like it!", :notice


		# todo -- add editable url for premium users and redirect there
		
	#	if !@book.backing_url.blank? && @book.author.user.subscribed?
	#		redirect_to @book.backing_url
	#	else
    #    	redirect_to @book
#		end
    end
end
