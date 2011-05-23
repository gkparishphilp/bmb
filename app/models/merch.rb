# == Schema Information
# Schema version: 20110327221930
#
# Table name: merches
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  owner_type        :string(255)
#  title             :string(255)
#  description       :text
#  inventory_count   :integer(4)      default(-1)
#  status            :string(255)     default("publish")
#  created_at        :datetime
#  updated_at        :datetime
#  inventory_warning :integer(4)      default(-1)
#  merch_type        :text
#

class Merch < ActiveRecord::Base
	validates	:title, :uniqueness => { :scope => [ :owner_id, :owner_type ] }
	#todo need to check these ownership relationships to make sure they don't conflict since they both use 'owners'
	belongs_to :owner, :polymorphic => true
	has_many :owners, :through => :ownings
	scope :published, where( "status = 'publish'" )
	scope :not_books, where("(merch_type <> 'hardcover' and merch_type <> 'trade_paperback' and merch_type <> 'paperback') or merch_type is null")
	
	belongs_to	:book #sometimes.... not necessarily
	
	has_many	:sku_items, :as => :item
	has_many	:skus, :through => :sku_items
	
	has_many	:reviews, :as => :reviewable
	
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :large => "300", :profile => "150", :thumb => "64", :tiny => "40"}}
	
	gets_activities
	
	attr_accessor	:price
	
	liquid_methods :title, :inventory_count, :inventory_warning

	def published?
		self.status == 'publish' ? (return true) : (return false)
	end
	
	def review_average
		return avg = self.reviews.average( :score ).to_f
	end
	
	def is_a_book?
		self.merch_type == 'hardcover' || self.merch_type == 'trade_paperback' || self.merch_type == 'paperback'
	end

end
