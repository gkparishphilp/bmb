class UploadEmailListsController < ApplicationController
	before_filter :get_author

	def create
		@upload_email_list = UploadEmailList.new params[:upload_email_list]
		filename = params[:upload_email_list][:file_name]
		@upload_email_list.sku_id = params[:upload_email_list][:sku_id]
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
					redirect_to author_admin_email_path
				elsif params[:upload_email_list][:list_type] == 'newsletter'
					redirect_to author_admin_email_path
				end
			else
				redirect_to author_admin_email_path
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

	def download
		#todo, scope coupons by sku_id 
		@sku = params[:sku]
		@coupons = Coupon.find_all_by_owner_id_and_owner_type_and_discount_type_and_discount( @author.id, 'Author', 'percent', 100)
		csv_string = CSV.generate do |csv|
			#header row
			csv << ["email address", "download url"]
			#data rows
			@coupons.each do |coupon|
				url = redeem_code_url(:code => coupon.code, :email => coupon.user.email )
				csv << [coupon.user.email, url]
			end
		end
		
		send_data csv_string,
			:type => 'text/csv; charset=iso-8859-1; header=present',
			:disposition => "attachment; filename = list.csv"
	end

	protected
	
	def get_author
		# TODO come back and fix this when admin panel is in place
		#@author = Author.find params[:author_id] if params[:author_id]
		@author = @current_user.author
	end

end
