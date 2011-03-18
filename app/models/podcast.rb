# == Schema Information
# Schema version: 20110318174450
#
# Table name: podcasts
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  owner_type  :string(255)
#  title       :string(255)
#  subtitle    :string(255)
#  itunes_id   :string(255)
#  description :text
#  keywords    :string(255)
#  explicit    :string(255)
#  status      :string(255)     default("publish")
#  cached_slug :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Podcast < ActiveRecord::Base
	validates	:title, :uniqueness => { :scope => [ :owner_id, :owner_type ] }

	belongs_to	:owner, :polymorphic => true
	has_many	:episodes
	
	
	has_friendly_id :title, :use_slug => :true
	gets_activities
	has_attached :avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :thumb => "100", :tiny => "40"}}
	
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
