class SiteAdminController < ApplicationController
	# for managing the site - blog posts, customer service, etc.
	
	layout '2col'
	# make sure @current_user is an author or admin -- set @admin = @current_site or @admin
	before_filter	:require_admin 
	helper_method	:sort_column, :sort_dir
	
	
	def blog
		@article = Article.new
		@articles = @current_site.articles.search( params[:q] ).order( sort_column( Article ) + " " + sort_dir ).paginate( :per_page => 10, :page => params[:page] )
	end
	
	private
	
	def sort_column( obj_type )
		obj_type.column_names.include?( params[:sort] ) ? params[:sort] : 'publish_at'
	end
	
	def sort_dir
		%w[ asc desc ].include?( params[:dir] ) ? params[:dir] : 'desc'
	end
end


