# == Schema Information
# Schema version: 20101110044151
#
# Table name: content_locations
#
#  id         :integer(4)      not null, primary key
#  asset_id   :integer(4)
#  path       :string(255)
#  content    :text(2147483647
#  created_at :datetime
#  updated_at :datetime
#

class ContentLocation < ActiveRecord::Base
	# Gives you the actual content for an asset 
	# The content may be on the filesystem (accessed via a path)
	# or in a longtext DB field on this object
	belongs_to	:asset
	
end
