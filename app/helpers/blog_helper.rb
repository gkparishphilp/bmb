module BlogHelper
	def blog_link( article )
		if article.owner.is_a? Author
			author_blog_path( article.owner, article )
		else
			blog_path( article)
		end
	end
end