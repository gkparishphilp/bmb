class AssetsController < ApplicationController
	before_filter   :get_parent
	layout			'3col'
	
	def new
		@type = params[:type]
		@asset = Asset.new
		@asset.title = "#{@book.title} (#{@type})"
	end
	
	def edit
		@asset = Asset.find params[:id]
		@type = @asset.type.downcase
	end
	
	def index
		@assets = @book.assets
	end
	
	def create
		case params[:type]
		when 'etext'
			@asset = @book.etexts.new params[:asset]
		when 'pdf'
			@asset = @book.pdfs.new params[:asset]
		when 'audio'
			@asset = @book.audios.new params[:asset]
		else
			@asset = @book.assets.new params[:asset]
		end
		
		if @asset.save
			# Check sku if type is sale
			if @asset.asset_type == 'sale'
				if params[:type] == 'etext' || params[:type] == 'pdf'
					sku = @current_author.skus.find_by_book_id_and_sku_type( @asset.book.id, 'ebook' )
					if sku.present?
						sku.add_item( @asset )
					else
						sku = @current_author.skus.create :sku_type => 'ebook', :title => "#{@asset.book.title} (eBook)", :description => @asset.description, :book_id => @asset.book.id, :price => @asset.price
						sku.add_item( @asset )
					end
				elsif params[:type] == 'audio'
					sku = @current_author.skus.find_by_book_id_and_sku_type( @asset.book.id, 'audio_book' )
					if sku.present?
						sku.add_item( @asset )
					else
						sku = @current_author.skus.create :sku_type => 'audio_book', :title => "#{@asset.book.title} (Audio Book)", :description => @asset.description, :book_id => @asset.book.id, :price => @asset.price
						sku.add_item( @asset )
					end
				end
			end
			
			process_attachments_for( @asset )
			@asset.reload
			@asset.update_attributes :title => @asset.title.gsub( /etext/i, "#{@asset.document.format}" )
			
			pop_flash 'Asset saved!', 'success'
		else
			pop_flash 'Asset could not be saved.', :error, @asset
		end

		redirect_to :back

	end
	
	def update
		@asset = Asset.find params[:id]
		
		if @asset.update_attributes params[:asset]
			process_attachments_for( @asset )
			pop_flash 'Asset saved!', 'success'
		else
			pop_flash 'Asset could not be saved.', :error, @asset
		end

		redirect_to :back
		
	end
	
	def download
		@asset = Asset.find params[:id]
		send_file @asset.document.location( nil, :full => true ), :disposition  => 'attachment', 
						:filename => @asset.book.title + "." + @asset.document.format
		#@asset.raw_stats.create :name =>'download', :ip => request.ip
		@asset.save
		@current_user.did_download @asset.book
		
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

end