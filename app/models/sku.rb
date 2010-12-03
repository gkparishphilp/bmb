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
	
	def items
		self.etexts + self.pdfs + self.audios + self.merches
	end
	
	def add_item( item )
		return self.sku_items.create :item_id => item.id, :item_type => item.class.name
	end
	
	def merch_sku?
		# A merch singleton sku -- contains merch, and only merch
		return self.sku_items.count == 1 && self.merches.first.present?
	end
	
	def book_sku?
		# either ebook or audiobook, not merch or bundle
		return self.sku_type == 'ebook' || self.sku_type == 'audio_book'
	end

	def contains_merch?
		for sku_item in self.sku_items
			return true if sku_item.item_type == 'Merch'
		end
		return false
	end
	
	def contains_etext?
		for sku_item in self.sku_items
			return true if sku_item.item_type == 'Etext'
		end
		return false
	end
end
