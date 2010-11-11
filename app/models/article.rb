# == Schema Information
# Schema version: 20101110044151
#
# Table name: articles
#
#  id               :integer(4)      not null, primary key
#  owner_id         :integer(4)
#  owner_type       :string(255)
#  title            :string(255)
#  excerpt          :string(255)
#  snip_at          :integer(4)
#  view_count       :integer(4)      default(0)
#  content          :text
#  status           :string(255)
#  comments_allowed :boolean(1)
#  publish_on       :datetime
#  article_type     :string(255)
#  cached_slug      :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

class Article < ActiveRecord::Base
	
	belongs_to :owner, :polymorphic => true
	
	has_many	:comments, :as => :commentable
	has_many	:raw_stats, :as => :statable
    
	has_friendly_id :title, :use_slug => :true
	acts_as_taggable_on	:topics
	acts_as_taggable_on	:keywords
	acts_as_followed
	gets_activities
	
	scope :published, where( "publish_on <= ? and status = 'publish'", Time.now )
		
	scope :recent, lambda { |*args|
		limit( args.first || 5 )
		order( 'publish_on desc' )
	}
	
	scope :dated_between, lambda { |*args| 
		where( "publish_on between ? and ?", (args.first || 1.day.ago), (args.second || Time.now) ) 
	} 
	
	scope :month_year, lambda { |*args| 
		where( " month(publish_on) = ? and year(publish_on) = ?", (args.first || Time.now.month), (args.second || Time.now.year) )
		order( 'publish_on desc' )
	}
	
	scope :year, lambda { |*args| 
		where( " year(publish_on) = ?", (args.first || Time.now.year) )
		order( 'publish_on desc' )
	}
	
	
	def related_articles
		return [] if self.keywords.empty?
		articles = Article.published.tagged_with( self.keywords, :any => true ).all
		articles.delete( self )
		return articles
	end
	
	def comments_allowed?
		return comments_allowed
	end
	
	def published?
		self.publish_on <= Time.now && self.status == 'publish'
	end
	
end
