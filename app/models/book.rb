# == Schema Information
# Schema version: 20110105172220
#
# Table name: books
#
#  id             :integer(4)      not null, primary key
#  author_id      :integer(4)
#  genre_id       :integer(4)
#  title          :string(255)
#  view_count     :integer(4)      default(0)
#  score          :integer(4)
#  subtitle       :string(255)
#  description    :text
#  status         :string(255)     default("publish")
#  age_aprop      :string(255)
#  rating_average :float
#  backing_url    :string(255)
#  cached_slug    :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

require 'amazon/ecs'
class Book < ActiveRecord::Base
	# represents a "title" or "work"
	
	validates	:title, :uniqueness => { :scope => :author_id }
	
	belongs_to	:author
	belongs_to  :genre
	
	has_many	:assets
	has_many	:etexts, :source => :assets
	has_many	:audios, :source => :assets
	has_many	:pdfs, :source => :assets
	
	has_many	:book_identifiers
	# todo -- add links
	has_many	:links, :as => :owner
	has_many	:reviews, :as => :reviewable
	has_many	:readings
	has_many	:readers, :through => :readings, :source => :user
	has_one		:upload_file
	has_many	:raw_stats, :as => :statable
	has_many	:skus
	
	has_attached	:avatar, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :large => "300", :profile => "150", :thumb => "64", :tiny => "40"}}
	
	gets_activities
	has_friendly_id			:title, :use_slug => :true
	acts_as_taggable_on		:tags
	
	attr_accessor :asin
	
	scope :published, where( "status = 'publish'" )
	
	# class_methods
	def self.find_on_amazon( title )
		Amazon::Ecs.item_search( title, :response_group => 'Medium', :search_index => 'Books' ).items
	end
	
	def self.create_from_asin( asin, author )
		# todo -- could use some error-catching
		@result = Amazon::Ecs.item_search( asin, :response_group => 'Medium', :search_index => 'Books' ).items.first
		if @result.nil?
			return false
		end
		book = author.books.new :title => @result.get( 'title' ), :description => @result.get_unescaped( 'editorialreview/content' )
		
		if book.save
			book.book_identifiers.create :identifier_type => 'asin', :identifier => @result.get('asin') if @result.get('asin')
			book.book_identifiers.create :identifier_type => 'isbn', :identifier => @result.get('isbn') if @result.get('isbn')
			book.book_identifiers.create :identifier_type => 'ean', :identifier => @result.get('ean') if @result.get('ean')
		
			avatar = Attachment.create_from_resource( @result.get('largeimage/url'), 'avatar', :owner => book, :remote => 'true' )
		
			book.links.create :title => "Amazon", :url => "http://www.amazon.com/dp/#{@result.get('asin')}/?tag=#{AMAZON_ASSOCIATE_ID}", :description => "Check out #{book.title} at Amazon" if @result.get('asin')
		
			book.links.create :title => "Google Books", :url => "http://books.google.com/books?vid=ISBN#{@result.get('isbn')}", :description => "Check out #{book.title} at Google Books" if @result.get('isbn')
		end
		
		return book
	end
	
	# Instance Methods
	def owner
		# for permissions
		return self.author
	end
	
	def ebook_sku
		self.skus.ebook.first
	end
	
	def audio_book_sku
		self.skus.audio_book.first
	end
	
	def merch_skus
		self.skus.merch
	end
	
	def custom_skus
		self.skus.custom
	end
	
	def review_average
		return avg = self.reviews.average( :score ).to_f
	end
	
	def add_asset( asset )
		ass = eval "#{asset.class.name}.create :book_id => self.id, :title => asset.title, :asset_type => asset.asset_type, :description => asset.description, :content => asset.content, :duration => asset.duration, :bitrate => asset.bitrate, :resolution => asset.resolution"
		ass.save
		return ass
	end
end
