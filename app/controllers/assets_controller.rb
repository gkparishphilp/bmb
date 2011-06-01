class AssetsController < ApplicationController
	before_filter   :get_parent, :except => :deliver
	layout			'2col'
	
	helper_method	:sort_column, :sort_dir
	
	
	def admin
		@assets = @book.assets.search( params[:q] ).order( sort_column + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
		render :layout => '2col'
	end
	
	def new
		@type = params[:type]
		@asset = Asset.new
		@asset.title = @book.title
	end
	
	def edit
		@asset = Asset.find params[:id]
		@type = @asset.type.downcase
		unless @asset.book.author == @current_author
			pop_flash "You don't own this!", :error
			redirect_to root_path
			return false
		end
	end
	
	def index
		@assets = @book.assets
	end
	
	def create
		if params[:attached_document_file].blank?
			pop_flash 'Please select a file to upload', :error
			redirect_to :back
			return false
		end
		
		if params[:asset][:type] == 'etext'
			@asset = @book.etexts.new( params[:asset] )
		else
			@asset = @book.audios.new( params[:asset] )
		end
		
		@asset.price = params[:asset][:price].to_f * 100 if params[:asset][:price]
		
		if @asset.save
			# Check sku if type is sale
			@asset.create_sku( @asset.type ) if @asset.asset_type == 'sale'
			process_attachments_for( @asset )
			@asset.reload # to bring the new attachemnt into the @asset model
			@asset.update_attributes :title => @asset.title.gsub( /etext/i, "#{@asset.document.format}" )
			pop_flash 'Asset saved!'

			redirect_to admin_author_book_assets_path( @current_author, @book )
			
		else
			pop_flash 'Asset could not be saved.', :error, @asset
			redirect_to :back
		end
	end
	
	
	def update
		@asset = Asset.find params[:id]
		unless @asset.book.author == @current_author
			pop_flash "You don't own this!", :error
			redirect_to root_path
			return false
		end
		
		case @asset.type
			
		when 'Etext'
			parameters = params[:etext].clone
		when 'Pdf'
			parameters = params[:pdf].clone
		when 'Audio'
			parameters = params[:audio].clone
		else
			parameters = params[:asset].clone
		end
		
		if @asset.update_attributes parameters
			process_attachments_for( @asset )
			pop_flash 'Asset updated!', 'success'
		else
			pop_flash 'Asset could not be saved.', :error, @asset
		end

		redirect_to digital_assets_author_book_path( @current_author, @book ) 
		
	end
	
	def download
		@asset = Asset.find params[:id]
		send_file @asset.document.location( nil, :full => true ), :disposition  => 'attachment', 
						:filename => @asset.book.title + "." + @asset.document.format
		@asset.raw_stats.create :name =>'download', :ip => request.ip
		@current_user.did_download @asset.book unless @current_user.anonymous?
	end
	
	def deliver
		@asset = Asset.find params[:id]
		@order = Order.find params[:order_id]
		if owning = Owning.find_by_sku_id_and_user_id( @order.sku.id, @order.user.id )
			if @current_user.anonymous? and owning.delivered == false
				if @asset.document.remote?
					@secure_url = @asset.generate_secure_url
					redirect_to @secure_url
				else
					send_file @asset.document.location( nil, :full => true ), :disposition  => 'attachment', 
							:filename => @asset.book.title + "." + @asset.document.format
				end
				owning.update_attributes :delivered => true
				@asset.raw_stats.create :name =>'download', :ip => request.ip				
			elsif @current_user.anonymous? and owning.delivered == true
				pop_flash "This item has already been delivered.  Please register or login as #{@order.email} to redownload this item.", :error
				redirect_to register_path
			elsif @current_user == @order.user
				if @asset.document.remote?
					@secure_url = @asset.generate_secure_url
					redirect_to @secure_url
				else
					send_file @asset.document.location( nil, :full => true ), :disposition  => 'attachment', 
							:filename => @asset.book.title + "." + @asset.document.format					
				end
				owning.update_attributes :delivered => true if owning.delivered == false
				@asset.raw_stats.create :name =>'download', :ip => request.ip
			else
				pop_flash "Sorry, you do not own this item", :error
				redirect_to root_path
			end
		else
			pop_flash "Sorry, could not deliver the file.", :error
			redirect_to root_path
		end
	end
	
	def destroy
		@asset = Asset.find params[:id]
		@asset.destroy
		pop_flash "Asset Deleted"
		redirect_to :back
	end
	
	
	private
	
	def get_parent
		@book = Book.find params[:book_id]
	end
	
	
	def sort_column
		Asset.column_names.include?( params[:sort] ) ? params[:sort] : 'title'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end

end