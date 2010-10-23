class Episode < ActiveRecord::Base
	validates_presence_of	:title
	validates_uniqueness_of	:title, :scope => :podcast_id
	validates_format_of 	:duration, :with => /\d*:\d*/, :message => 'Must be in the format hh:mm:ss'
	
	has_many :comments, :as => :commentable
	belongs_to	:podcast
	
	#acts_as_followable
	
	has_friendly_id :title, :use_slug => :true
	
	def url
		"http://" + APP_DOMAIN + "/system/audio/podcasts/#{self.podcast.id}/#{self.id}/" + self.friendly_id + ".mp3"
	end
	
end