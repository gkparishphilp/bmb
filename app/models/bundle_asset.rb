class BundleAsset < ActiveRecord::Base
	belongs_to :bundle
	belongs_to	:asset
end