# == Schema Information
# Schema version: 20101026212141
#
# Table name: episodes
#
#  id          :integer(4)      not null, primary key
#  podcast_id  :integer(4)
#  status      :string(255)
#  title       :string(255)
#  subtitle    :string(255)
#  keywords    :string(255)
#  duration    :string(255)
#  description :text
#  filesize    :integer(4)
#  filename    :string(255)
#  explicit    :string(255)
#  transcript  :text
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
	
	#acts_as_followable
	
	has_friendly_id :title, :use_slug => :true
	
	def url
		"http://" + APP_DOMAIN + "/system/audio/podcasts/#{self.podcast.id}/#{self.id}/" + self.friendly_id + ".mp3"
	end
	
end
