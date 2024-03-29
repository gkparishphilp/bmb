# == Schema Information
# Schema version: 20110826004210
#
# Table name: merches
#
#  id                      :integer(4)      not null, primary key
#  owner_id                :integer(4)
#  owner_type              :string(255)
#  title                   :string(255)
#  description             :text
#  inventory_count         :integer(4)      default(-1)
#  status                  :string(255)     default("publish")
#  created_at              :datetime
#  updated_at              :datetime
#  inventory_warning       :integer(4)      default(-1)
#  merch_type              :text
#  show_inventory_count_at :integer(4)      default(0)
#  book_id                 :integer(4)
#

class Merch < ActiveRecord::Base
	validates	:title, :uniqueness => { :scope => [ :owner_id, :owner_type ] }
	
	before_save	:sanitize_inventory
	
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to :owner, :polymorphic => true
	has_many :owners, :through => :ownings
	
	
	scope :published, where( "status = 'publish'" )
	scope :not_books, where("(merch_type <> 'hardcover' and merch_type <> 'trade paperback' and merch_type <> 'paperback') or merch_type is null")
	
	belongs_to	:book #sometimes.... not necessarily
	
	has_many	:sku_items, :as => :item
	has_many	:skus, :through => :sku_items
	
	has_many	:reviews, :as => :reviewable
	
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :large => "300", :profile => "150", :thumb => "64", :tiny => "40"}}
	
	searchable_on [ :title ]
	
	attr_accessor	:price
	
	liquid_methods :title, :inventory_count, :inventory_warning

	def published?
		self.status == 'publish' ? (return true) : (return false)
	end
	
	def review_average
		return avg = self.reviews.average( :score ).to_f
	end
	
	def sku
		SkuItem.where("item_id = #{self.id} and item_type = '#{self.class.name}'").first.sku
	end
	
	def formatted_title
		title = "Merch "
		title += "(#{self.merch_type.capitalize})" if self.merch_type
	end
	
	
	def is_a_book?
		self.merch_type == 'hardcover' || self.merch_type == 'trade paperback' || self.merch_type == 'paperback'
	end
	
	def sanitize_inventory
		self.inventory_count = -1 if self.inventory_count.nil?
		self.inventory_warning = 0 if self.inventory_warning.nil?
		self.show_inventory_count_at = -1 if self.show_inventory_count_at.nil?
	end

end
