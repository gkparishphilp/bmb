# == Schema Information
# Schema version: 20110318174450
#
# Table name: skus
#
#  id                           :integer(4)      not null, primary key
#  owner_id                     :integer(4)
#  owner_type                   :string(255)
#  book_id                      :integer(4)
#  title                        :string(255)
#  description                  :text
#  price                        :integer(4)
#  sku_type                     :string(255)
#  status                       :string(255)     default("publish")
#  created_at                   :datetime
#  updated_at                   :datetime
#  domestic_shipping_price      :integer(4)      default(0)
#  international_shipping_price :integer(4)      default(0)
#  allow_comment                :boolean(1)
#  number_remaining             :integer(4)      default(-1)
#  listing_order                :integer(4)
#

class Sku < ActiveRecord::Base
	# Can do the reverse polymorphic through relationship this way, but I'm not gonna
	# cause it requires 3 queries vs one, and cause I'd rather explicitly define the 
	# kinds of things that can be sold in a sku rather than letting it be truly 
	# polymoprphic to any object.
	#def items
	#	self.sku_items.collect{ |si| si.item }
	#end

	after_create :assign_listing_order
	
	has_many :coupons
	has_many :orders

	# The author
	belongs_to	:owner, :polymorphic => true
	
	# a skus users are the people who've bought it
	has_many	:ownings
	has_many	:users, :through => :ownings

	has_many :sku_items
	
	has_many :etexts, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Etext'"
						
	has_many :pdfs, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Pdf'"
						
	has_many :audios, :through => :sku_items, :source => :asset,
						:conditions => "sku_items.item_type = 'Audio'"
						
	has_many :merches, :through => :sku_items, :source => :merch,
						:conditions => "sku_items.item_type = 'Merch'"
						
	has_many :subscriptions, :through => :sku_items, :source => :subscription,
						:conditions => "sku_items.item_type = 'Subscription'"

	belongs_to	:book
	
	attr_accessor :item
	
	scope	:ebook, where( "sku_type = 'ebook'" )
	scope	:audio_book, where( "sku_type = 'audio_book'" )
	scope	:merch, where( "sku_type = 'merch'" )
	scope	:custom, where( "sku_type = 'custom'" )
	scope 	:subscription, where( "sku_type = 'subscription'")
	
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :large => "300", :profile => "150", :thumb => "64", :tiny => "40"}}
	liquid_methods :title, :owner, :sku_items

	def assign_listing_order
		for sku in self.owner.skus
			sku.update_attributes :listing_order => sku.listing_order.to_i + 1
		end
		self.update_attributes :listing_order => 0
	end
	
	def allow_comment?
		return self.allow_comment
	end
	
	def items
		self.etexts + self.pdfs + self.audios + self.merches
	end
	
	def add_item( item )
		return self.sku_items.create :item_id => item.id, :item_type => item.class.name
	end
	
	def merch_sku?
		# Previous function (return self.sku_items.count == 1 && self.merches.first.present?) didn't work when there were two items in a sku and both were merch, so...
		# Collect all the items in a sku, and then check to see if each item is a merch.  If there is a non-merch item, then a 'false' value will appear, so merch_sku? should be false
		if self.sku_items.collect{ |item| item.is_a? Merch}.include?(false)
			return false
		else
			return true
		end
	end
	
	def book_sku?
		# either ebook or audiobook, not merch or bundle
		return self.sku_type == 'ebook' || self.sku_type == 'audio_book'
	end

	def contains_merch?
		for sku_item in self.sku_items
			return true if sku_item.item_type == 'Merch'
		end
		
		#todo - remove this and return false when Sigler flash drive sku is fixed or keep and use shipping_price as an additional check for merchandise status		
		if self.domestic_shipping_price.present? or self.international_shipping_price.present? 
			return true 
		else
			return false
		end
		
	end
	
	def contains_etext?
		for sku_item in self.sku_items
			return true if sku_item.item_type == 'Etext'
		end
		return false
	end
	
	def contains_audio?
		for sku_item in self.sku_items
			return true if sku_item.item_type == 'Audio'
		end
		return false
	end
	
	def decrement_inventory
		for item in self.sku_items
			if item.item_type == 'Merch' and item.merch.inventory_count > 0
				item.merch.update_attributes :inventory_count => item.merch.inventory_count - 1
				item.check_inventory_level
			end
		end
	end
	
end
