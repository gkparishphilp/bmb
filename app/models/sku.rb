# == Schema Information
# Schema version: 20101120000321
#
# Table name: skus
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  owner_type  :string(255)
#  book_id     :integer(4)
#  title       :string(255)
#  description :text
#  price       :integer(4)
#  sku_type    :string(255)
#  status      :string(255)     default("publish")
#  created_at  :datetime
#  updated_at  :datetime
#

class Sku < ActiveRecord::Base
	# Can do the reverse polymorphic through relationship this way, but I'm not gonna
	# cause it requires 3 queries vs one, and cause I'd rather explicitly define the 
	# kinds of things that can be sold in a sku rather than letting it be truly 
	# polymoprphic to any object.
	#def items
	#	self.sku_items.collect{ |si| si.item }
	#end
	
	has_many :coupons, :as => :redeemable
	has_many :orders, :as => :ordered
	
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to	:owner, :polymorphic => true
	has_many	:owners, :through => :ownings

	has_many :etexts, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Etext'"
						
	has_many :pdfs, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Pdf'"
						
	has_many :audios, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Audio'"
						
	has_many :merches, :through => :sku_items, :source => :merch,
						:conditions => "sku_items.item_type = 'Merch'"
						
	has_many :sku_items
	
	belongs_to	:book
	
	attr_accessor :item
	
	scope	:ebook, where( "sku_type = 'ebook'" )
	scope	:audio_book, where( "sku_type = 'audio_book'" )
	scope	:merch, where( "sku_type = 'merch'" )
	scope	:custom, where( "sku_type = 'custom'" )
	
	def items
		self.etexts + self.pdfs + self.audios + self.merches
	end
	
	def add_item( item )
		return self.sku_items.create :item_id => item.id, :item_type => item.class.name
	end

	
	
end
