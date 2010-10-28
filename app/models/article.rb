# t.integer  "owner_id"
# t.string   "owner_type"
# t.string   "title"
# t.string   "excerpt"
# t.integer  "snip_at"
# t.integer  "view_count",       :default => 0
# t.text     "content"
# t.string   "status"
# t.boolean  "comments_allowed"
# t.datetime "publish_on"
# t.string   "article_type"
# t.string   "cached_slug"
# t.datetime "created_at"
# t.datetime "updated_at"

class Article < ActiveRecord::Base
	has_many	:comments, :as => :commentable
	has_many	:raw_stats, :as => :statable
    
	has_friendly_id :title, :use_slug => :true
	acts_as_taggable_on	:topics
	acts_as_taggable_on	:tags
	
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
		articles = Article.published.tagged_with( self.tags )
		articles.delete( self )
		return articles
	end
	
	
	def comments_allowed?
		return comments_allowed
	end
	
end