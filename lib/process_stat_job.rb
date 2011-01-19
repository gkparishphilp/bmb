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
			stat_event = StatEvent.create(	:statable_id => stat.statable_id,
			 								:statable_type => stat.statable_type,
											:name => stat.name,
											:ip => stat.ip,
											:count => stat.count,
											:extra_data => stat.extra_data
										)
		end	
		
	end
	
end
