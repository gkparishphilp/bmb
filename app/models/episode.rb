# == Schema Information
# Schema version: 20110121210536
#
# Table name: episodes
#
#  id          :integer(4)      not null, primary key
#  podcast_id  :integer(4)
#  title       :string(255)
#  subtitle    :string(255)
#  keywords    :string(255)
#  duration    :string(255)
#  description :text
#  explicit    :string(255)
#  transcript  :text
#  status      :string(255)     default("publish")
#  cached_slug :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Episode < ActiveRecord::Base
	validates_presence_of	:title
	validates_uniqueness_of	:title, :scope => :podcast_id
	validates_format_of 	:duration, :with => /\d*:\d*/, :message => 'Must be in the format hh:mm:ss'
	
	has_many :comments, :as => :commentable
	belongs_to	:podcast
	
	has_attached :audio, :formats => ['mp3', 'aac', 'wav', 'ogg']
	
	has_friendly_id :title, :use_slug => :true
	acts_as_followed
	gets_activities
	
	def url
		"http://" + APP_DOMAIN + "/system/audio/podcasts/#{self.podcast.id}/#{self.id}/" + self.friendly_id + ".mp3"
	end
	
	def owner
		return self.podcast.owner
	end
	
end
