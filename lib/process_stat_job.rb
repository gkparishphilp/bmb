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
			
			#Record in the stat_event table, for posterity if nothing else...
			stat_event = StatEvent.create(	:statable_id => stat.statable_id,
			 								:statable_type => stat.statable_type,
											:name => stat.name,
											:ip => stat.ip,
											:count => stat.count,
											:extra_data => stat.extra_data
										)
										
			#Update counters on object, don't want to be dynamically tallying these every time for CPU reasons							
			case stat.statable_type
			when 'Book'
				book = Book.find stat.statable_id
				book.update_attributes :view_count => book.view_count + 1 if stat.name == 'view'
			when 'Asset'
				asset = Asset.find stat.statable_id
				asset.update_attributes :download_count => asset.download_count + 1 if stat.name =='download'
			when 'Post'		
				post = Post.find stat.statable_id
				post.update_attributes :view_count => post.view_count + 1
			when 'Article'
				article = Article.find stat.statable_id
				article.update_attributes :view_count => article.view_count + 1
			end
		end	
		
	end
	
end
