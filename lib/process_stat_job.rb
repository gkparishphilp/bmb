class ProcessStatJob  < Struct.new(:now, :stat)
	
	def perform
			
		case stat.name
			when 'view'
				max_rate_per_minute = 2
				interval_in_minute = 1
			when 'download'
				max_rate_per_minute = 100
				interval_in_minute = 60
		end

		past = now - interval_in_minute.minutes
		
		count = RawStat.where("created_at BETWEEN ? and ? and ip = ? and name = ?", past, now, stat.ip, stat.name).count
		
		if count < max_rate_per_minute * interval_in_minute
			case stat.statable_type
			when 'Book'
				book = Book.find stat.statable_id
				if stat.name == 'view'
					book.view_count += 1
					book.save
				end
			when 'Asset'
				asset = Asset.find stat_statable_id
				book = asset.book
				if stat.name == 'download'
					book.view_count += 1
					book.save
				end
			when 'Post'
				post = Post.find stat.statable_id
				post.view_count += 1
				post.save
			when 'Article'
				article = Article.find stat.statable_id
				article.view_count += 1
				article.save
			end
		end	
		
	end
	
end
