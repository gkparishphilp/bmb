class UploadEmailListsController < ApplicationController
	before_filter   :require_login, :get_author

	def create
		@upload_email_list = UploadEmailList.new params[:upload_email_list]
		filename = params[:upload_email_list][:file_name]
		@upload_email_list.book_id = params[:upload_email_list][:book_id]
		@upload_email_list.list_type = params[:upload_email_list][:list_type]
		
		@upload_email_list.author = @author
		
		if @author
			@upload_email_list.file_path = @current_user.author.id.to_s + '_' + filename.original_filename
		else
			@upload_email_list.file_path = 'BmB_' + filename.original_filename
		end
		if @upload_email_list.save
			flash[:success] = 'Email list was successfully imported.'
			if @author
				#TODO Need to fix these redirect_to paths
				if params[:upload_email_list][:list_type] == 'giveaway'
					redirect_to giveaways_coupons_path
				else
					redirect_to emails_admin_path
				end
			else
				redirect_to admin_email_subscriptions_path
			end
		else
			flash[:error] = 'Oooops, UploadEmailList not saved...'
			@upload_email_list.errors.each do |field, msg|
				flash[:error] += "<br>" + field + ": " if field
				flash[:error] += " " + msg
			end
			render :action => :new
		end
	end

	protected
	
	def get_author
		# TODO come back and fix this when admin panel is in place
		#@author = Author.find params[:author_id] if params[:author_id]
		@author = @current_user.author
	end

end
