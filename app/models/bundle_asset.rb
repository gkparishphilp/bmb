# == Schema Information
# Schema version: 20101110044151
#
# Table name: bundle_assets
#
#  id         :integer(4)      not null, primary key
#  bundle_id  :integer(4)
#  asset_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class BundleAsset < ActiveRecord::Base
	belongs_to :bundle
	belongs_to	:asset
end
