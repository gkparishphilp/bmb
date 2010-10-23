class TopicsController < ApplicationController
	before_filter :require_login, :except => [:index, :show]
	before_filter :get_parent

	def index
		@topics = @forum.topics.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
		@topic = Topic.new
	end

	def show
		@topic = Topic.find(params[:id])
		@forum = @topic.forum
		@posts = @topic.posts.paginate :page => params[:page], :order => 'created_at ASC', :per_page => 10
		@post = Post.new
		
		#rs = @topic.raw_stats.create :name => 'view', :ip => request.ip
	end

	def edit
		@topic = Topic.find params[:id]
		require_user_owns( @topic )
	end

	def update
		@topic = Topic.find params[:id]
		require_user_owns( @topic )

		if @topic.update_attributes(params[:topic])
			pop_flash 'Topic was successfully updated.'
			redirect_to forum_topic_path( @forum, @topic )
		else
			pop_flash 'Topic not saved', :error, @topic
			redirect_to edit_forum_topic_path( @forum, @topic )
		end
	end

	def new
		@topic = Topic.new
	end

	def create
		@topic = Topic.new(params[:topic])
		@topic.user = @current_user
		@topic.ip = request.ip
		if ( @forum.topics << @topic )
			flash[:notice] = "Topic added"
			redirect_to forum_topics_path( @topic.forum )
		else
			flash[:notice] = "Ooooops"
			@topic.errors.each do |field, msg|
				flash[:notice] += "<br>" + field + ": "if field
				flash[:notice] += " " + msg
			end
			redirect_to new_forum_topic_path( @topic.forum )
		end
	end
	
private

	def get_parent
		@forum_id = params[:forum_id]
		return ( redirect_to( forums_url ) ) unless @forum_id
		@forum = Forum.find( @forum_id )
		@author = Author.find params[:author_id] if params[:author_id]
	end 
end
