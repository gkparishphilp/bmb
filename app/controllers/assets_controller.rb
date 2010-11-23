class AssetsController < ApplicationController
	before_filter   :get_parent
	layout			'3col'
	
	def new
		@type = params[:type]
		@asset = Asset.new
		@asset.title = "#{@book.title} (#{@type})"
		@asset.asset_type = "preview/sample, giveaway, for_sale"
	end
	
	def edit
		@asset = Asset.find params[:id]
		@type = @asset.type.downcase
	end
	
	def create
		case params[:type]
		when 'ebook'
			@asset = @book.ebooks.new params[:asset]
		when 'pdf'
			@asset = @book.pdfs.new params[:asset]
		when 'audio_book'
			@asset = @book.audio_books.new params[:asset]
		else
			@asset = @book.assets.new params[:asset]
		end
		
		if @asset.save
			# Check sku if type is sale
			if @asset.asset_type == 'sale'
				# if params[:type] == 'ebook'
					# find_or_create ebook sku
					# add asset as item
				# if params[:type] == 'audio'
					# find_or_create audio sku
					# add asset as item
			end
			process_attachments_for( @asset )
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
		send_file @asset.etext.location( nil, :full => true ), :disposition  => 'attachment', 
						:filename => @asset.book.title + "." + @asset.etext.format
		@asset.raw_stats.create :name =>'download', :ip => request.ip
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