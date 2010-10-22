module RpxHelper
  
	def iframe_src ( action )
		if @current_user.anonymous?
			src = "https://todo.rpxnow.com/openid/embed?token_url=http://#{request.host}:#{request.port}/#{action}?dest=#{@dest}"
		else
			src = "https://todo.rpxnow.com/openid/embed?token_url=http://#{request.host}:#{request.port}/#{action}?user_id=#{@current_user.id}"
		end
	end
  
end