# == Schema Information
# Schema version: 20101103181324
#
# Table name: podcasts
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  title       :string(255)
#  subtitle    :string(255)
#  itunes_id   :string(255)
#  description :text
#  duration    :string(255)
#  filename    :string(255)
#  keywords    :string(255)
#  filesize    :integer(4)
#  explicit    :string(255)
#  status      :string(255)
#  cached_slug :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Podcast < ActiveRecord::Base
	validates_presence_of	:title
	validates_uniqueness_of	:title

	belongs_to	:owner, :polymorphic => true
	has_many	:episodes
	
	
	has_friendly_id :title, :use_slug => :true
	
	def url
		"http://" + APP_DOMAIN + "/system/audio/" + self.friendly_id + ".mp3"
	end
	
	def ping_itunes
		unless self.itunes_id.blank?
			itunes_ping = Net::HTTP.new('phobos.apple.com', 443)
			itunes_ping.use_ssl = true
			path = "/WebObjects/MZFinance.woa/wa/pingPodcast"
			args = "id=#{self.itunes_id}"
			http_resp, response_data = itunes_ping.post( path, args )
		end
	end
	
	
end
