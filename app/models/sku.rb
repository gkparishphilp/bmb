# == Schema Information
# Schema version: 20101110044151
#
# Table name: skus
#
#  id          :integer(4)      not null, primary key
#  owner_id    :integer(4)
#  owner_type  :string(255)
#  title       :string(255)
#  description :text
#  price       :integer(4)
#  status      :string(255)     default("publish")
#  created_at  :datetime
#  updated_at  :datetime
#

class Sku < ActiveRecord::Base
	
	validates	:item_id, :uniqueness => { :scope => [ :item_type ], :message => "Item is already in the Sku" }
	
	has_many :sku_items

	has_many :ebooks, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Ebook'"
						
	has_many :pdfs, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Pdf'"
						
	has_many :audio_books, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'AudioBook'"
						
	has_many :merches, :through => :sku_items, :source => :merch,
						:conditions => "sku_items.item_type = 'Merch'"
	def items
		self.ebooks + self.pdfs + self.audio_books + self.merches
	end
	
	def add_item( item )
		self.sku_items.create :item_id => item.id, :item_type => item.class.name
	end

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
	
end
