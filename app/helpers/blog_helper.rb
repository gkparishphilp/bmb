module BlogHelper
	def blog_link( article )
		if article.owner.is_a? Author
			author_blog_url( article.owner, article )
		else
			blog_url( article)
		end
	end
	
	def blog_index_link( args={} )
		if @author
			author_blog_index_path( @author, args )
		else
			blog_index_path( args )
		end
	end
end