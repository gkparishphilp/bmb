class Topic < Post
	belongs_to  :forum
	#belongs_to  :user
	has_many    :posts

	has_many :raw_stats, :as => :statable

	has_friendly_id :title, :use_slug => :true

	validates_presence_of	:title
	validates_presence_of	:content, :message => "You have to have something to say to post a topic :)"


end