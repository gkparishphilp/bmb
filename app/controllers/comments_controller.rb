class CommentsController < ApplicationController
	before_filter   :get_commentable
	
	def new
		@comment = Comment.new
	end

	def edit
		@comment = @commentable.comments.find  params[:id]
		require_user_owns( @comment )
	end

	def create
		@comment = Comment.new params[:comment]
		@comment.user = @current_user
		@comment.ip = request.ip
		#need to bypass recaptcha is current_user is logged in or human....
		if @current_user.anonymous? && !@current_user.human?
			if verify_recaptcha(:model => @comment) && ( @commentable.comments << @comment )
				pop_flash "Thanks for your comment!"
				cookies[:human] = { :value => 'true', :expires => 10.minutes.from_now }
			else
				pop_flash "There was a problem with your comment: ", :error, @comment
			end
		elsif ( @commentable.comments << @comment )
			pop_flash "Thanks for your comment!"
		else
			pop_flash "There was a problem with your comment: ", :error, @comment
		end
		# redirect_to polymorphic_url @commentable
		# we're going back to the parent resource no matter what...
		# But the site blog is a special case since it uses a different controller
		# from the resource name, and has no parent
		redirect_to blog_path @commentable
		
	end #create

	def update
		@comment = @commentable.comments.find params[:id] 

		require_user_owns( @comment )

		if @comment.update_attributes params[:comment] 
			pop_flash "Comment was successfully updated."
			# see notes on create redirect for why this goes to blog_path rather than polymorphic_url
			redirect_to blog_path @commentable
		else
			pop_flash "There was a problem with your comment: ", :error, @comment
			render :action => :edit
		end
	end

	def destroy
		@comment = Comment.find(params[:id])
		@comment.destroy
		pop_flash 'Comment was successfully deleted.'
		redirect_to polymorphic_url @commentable
	end
	
private 

	def get_commentable
		# so far, only articles are commentable
		@commentable = Article.find params[:article_id] if params[:article_id]
	end 
	
	

end
