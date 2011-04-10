# == Schema Information
# Schema version: 20110327221930
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
#  listing_order                :integer(4)
#  show_inventory               :boolean(1)
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
	scope	:subscription, where( "sku_type = 'subscription'" )
	scope   :published, where( "status = 'publish'" )
	scope   :has_merch, :joins => :sku_items, :select => 'distinct skus.*', :conditions => "sku_items.item_type = 'Merch'"
	scope   :for_author, lambda { |args|
		where( "owner_type='Author' and owner_id = ?", args )
	}
	
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
	
	def published?
		self.status == 'publish' ? (return true) : (return false)
	end
	
	def sold_out?
		self.sku_items.each do |sku_item|
			return true if sku_item.item_type == 'Merch' and sku_item.item.inventory_count < 1
		end
		return false
	end
	
	def show_inventory?
		#todo - this needs to be cleaned up when all the merch, sku, sku_item relationships are figured out
		
		# First, check to see if the sku contains merch?  If it doesn't, then don't show inventory since its a virtual good
		if self.contains_merch?
			inventory = self.sku_item_counts
			# If you've set the show_inventory_count_at to -1 to signify that you never want to show a countdown, you'll get an inventory array with no elements.  Return false in this case  
			if inventory.count == 0
				return false
			else
				#Sort by inventory, and if the smallest quantity item in your sku bundle has crossed its show_inventory_count_at number, then return the number
				inventory.sort! {|a,b| a[0] <=> b[0]}
				inventory.first[0] < inventory.first[1] ? (return inventory.first[0]) : (return false)
			end
		end

		return false

	end
	
	def sku_item_counts
		#returns an array with the inventory_count, and show_inventory_count_at attributes
		inventory = Array.new
		self.sku_items.each do |sku_item|
			inventory << [sku_item.item.inventory_count, sku_item.item.show_inventory_count_at] if (sku_item.item_type == 'Merch' && sku_item.item.inventory_count >= 0)
		end
		return inventory
	end
	
	def remaining_quantity
		#returns a single number that is the remaining quantity for a sku
		inventory = self.sku_item_counts
		inventory.sort! {|a,b| a[0] <=> b[0]}
		return inventory.first[0]
	end
	
	def items
		self.etexts + self.pdfs + self.audios + self.merches
	end
	
	def add_item( item )
		return self.sku_items.create :item_id => item.id, :item_type => item.class.name
	end
	
	def merch_sku?
		#merch_sku? means that there is ONLY merch in the sku
		# Previous function (return self.sku_items.count == 1 && self.merches.first.present?) didn't work when there were two items in a sku and both were merch, so...
		# Collect all the items in a sku, and then check to see if each item is a merch.  If there is a non-merch item, then a 'false' value will appear, so merch_sku? should be false
		if self.sku_items.collect{ |item| item.item.is_a? Merch}.include?(false)
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
	
	def decrement_inventory_by( quantity )
		for sku_item in self.sku_items
			if sku_item.item_type == 'Merch' and sku_item.merch.inventory_count > 0
				sku_item.merch.update_attributes :inventory_count => sku_item.merch.inventory_count - quantity
				sku_item.check_inventory_warning
			end
		end
	end
	
end
