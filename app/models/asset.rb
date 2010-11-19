# == Schema Information
# Schema version: 20101110044151
#
# Table name: assets
#
#  id                 :integer(4)      not null, primary key
#  book_id            :integer(4)
#  type               :string(255)
#  title              :string(255)
#  description        :text
#  download_count     :integer(4)      default(0)
#  asset_type         :string(255)
#  unlock_requirement :string(255)
#  content            :text(2147483647
#  duration           :string(255)
#  bitrate            :string(255)
#  resolution         :string(255)
#  word_count         :integer(4)
#  origin             :string(255)
#  status             :string(255)     default("publish")
#  created_at         :datetime
#  updated_at         :datetime
#

class Asset < ActiveRecord::Base
	# represents a book's 'product'
	# the digital assets we have for a book
	# may be the full work in some digital format
	# or a sample, or a bonus, or a giveaway, etc.
	has_many	:sku_items, :as => :item
	has_many	:skus, :through => :sku_items
	
	has_many	:coupons, :as => :redeemable
	has_many	:orders, :as  => :ordered
	belongs_to	:book
	
	has_many	:owners, :through => :ownings
	
end

# ok, we're trying to STI this thing to cover the different kinds of attachemnts.  Rails3 seems
# to require namespacing for STI
class Asset::Ebook < Asset
	has_attached :etext, :formats => ['html', 'doc', 'txt', 'rtf', 'epub', 'mobi', 'docx', 'odt', 'htm'], :private => true
end

class Asset::Pdf < Asset
	has_attached :pdf, :formats => ['pdf'], :private => true
end

class Asset::AudioBook < Asset
	has_attached :audio, :formats => ['mp3', 'aac', 'wav', 'ogg'], :private => true
end
