# == Schema Information
# Schema version: 20101110044151
#
# Table name: sites
#
#  id         :integer(4)      not null, primary key
#  owner_id   :integer(4)
#  owner_type :string(255)
#  name       :string(255)
#  domain     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Site < ActiveRecord::Base
	has_many :roles
	has_many :admins, :through => :roles, :source => :user, :conditions => "role = 'admin'"
	has_many :contributors, :through => :roles, :source => :user, :conditions => "role = 'contributor'"
	
	has_many :articles, :as => :owner
	has_many :forums, :as => :owner
	has_many :podcasts, :as => :owner
	
	has_many :links, :as => :owner
	has_many :twitter_accounts, :as => :owner
	has_many :facebook_accounts, :as => :owner
	
	has_many :users
	has_many :static_pages
	has_many :contacts
	has_many :crashes
	does_activities
	
	def create_models
		@legacy_models = Dir.glob('/Users/tay/Sites/elit/app/models/*.rb').collect { |model_path| File.basename(model_path).gsub('.rb', '') }

		base_model_filepath = '/Users/tay/Sites/bmb/app/models/'

		for model in @legacy_models
			#Need to gsub out the _ in model names in legacy_models to properly name the Model in model.rb
			model_def = <<EOS
class V15#{model.capitalize} < ActiveRecord::Base
end
EOS
			model_path = base_model_filepath + 'v15_' + model + '.rb'
			File.open(model_path, 'w') {|f| f.write(model_def) }

		end
	end


	def migrate_users
		# Has attachments
		old_users = V15User.find(:all)
		for old_user in old_users
			user = User.new
			user.id = old_user.id
			user.site_id = 1
			user.email = old_user.email
			user.name = old_user.user_name
			user.score = old_user.score
			user.website_name = old_user.website_name
			user.bio = old_user.bio
			user.hashed_password = old_user.hashed_password
			user.salt = old_user.salt
			user.remember_token = old_user.remember_token
			user.remember_token_expires_at = old_user.remember_token_expires_at
			user.activation_code = old_user.activation_code
			user.activated_at = old_user.activated_at
			user.status = old_user.status
			user.name_changes = old_user.name_changes
			user.tax_id = old_user.ssn
			user.orig_ip = old_user.orig_ip
			user.last_ip = old_user.last_ip
			user.created_at = old_user.created_at
			user.updated_at = old_user.updated_at
			user.save( false )
		end
	end
	
	def migrate_authors
		# Has attachments
		old_authors = V15Author.find(:all)
		for ao in old_authors
			a=Author.new
			a.id = ao.id
			a.user_id = ao.user_id
			a.featured_book_id = ao.featured_book_id
			a.pen_name = ao.pen_name
			a.subdomain = ao.pen_name #need to make this URL safe
			a.bio = ao.bio
			a.score = ao.score
			a.created_at = ao.created_at
			a.updated_at = ao.updated_at
			a.save
		end
	end
	
	def migrate_articles
		old_articles = V15Article.find(:all)
		for ao in old_articles
			a=Article.new
			a.id = ao.id
			if ao.author_id.nil?
				a.owner_id = 1
				a.owner_type = 'Site'
			else 
				a.owner_id = ao.author_id
				a.owner_type = 'Author'
			end
			
			a.save
		end	
	end
	
	def migrate_author_links
		old_links = V15AuthorLink.find(:all)
		for ol in old_links
			l=Link.new
			l.owner_id = ol.author_id
			l.owner_type = 'Author'
			l.title = ol.title
			l.url = ol.url
			l.description = ol.description
			l.created_at = ol.created_at
			l.updated_at = ol.updated_at
			l.save
		end
	end
	
	def migrate_backing
		old_backings = V15Backing.find(:all)
		for ob in old_backings
			b=Backing.new
			b=ob
			b.save
		end
	end
	
	def migrate_backing_events
		old_backings = V15BackingEvent.find(:all)
		for ob in old_backings
			b=BackingEvent.new
			b=ob
			b.save
		end
	end
	
	def migrate_badges
		# Has attachments
		old_badges = V15Badges.find(:all)
		for ob in old_badges
			b=Badge.new
			b.id = ob.id
			b.name = ob.name
			b.display_name = ob.display_name
			b.badge_type = ob.badge_type
			b.description = ob.description
			b.level = ob.level
			b.created_at = ob.created_at
			b.updated_at = ob.updated_at
			b.save
		end
	end
	
	def migrate_badgings
		old_badgings = V15Badgings.find(:all)
		for ob in old_badgings
			b=Badging.new
			b.id = ob.id
			b.badge_id = ob.badge_id
			b.badgable_id = ob.user_id
			b.badgable_type = 'User'
			b.created_at = ob.created_at
			b.updated_at = ob.updated_at
			b.save
		end
	end
	
	def migrate_bkasset
	end
	
	def migrate_bkcontent
	end
	
	def migrate_bkfile
	end
	
	def migrate_books
		# has attached files
		old_books = V15Book.find(:all)
		for ob in old_books
			b=Book.new
			b.id = ob.id
			b.author_id = ob.author_id
			b.genre_id = ob.genre_id
			b.title = ob.title
			b.view_count = ob.view_count
			b.score = ob.score
			b.subtitle = ob.subtitle
			b.description = ob.long_desc
			b.status = ob.status
			b.age_aprop = ob.age_aprop
			b.rating_average = ob.rating_average
			b.backing_url = ob.backing_url
			b.created_at = ob.created_at
			b.updated_at = ob.updated_at
			b.save
		end
	end
	
	def migrate_book_asset
	end
	
	def migrate_comments
		old_comments = V15Comment.find(:all)
		for oc in old_comments
			c=Comment.new
			c.id = oc.id
			c.user_id = oc.user_id
			c.commentable_type = oc.commentable_type
			c.commentable_id = oc.article_id
			c.ip = oc.ip
			c.content = oc.content
			c.created_at = oc.created_at
			c.updated_at = oc.updated_at
			c.save
		end
	end
	
	def migrate_contacts
		old_contacts = V15Contact.find(:all)
		for oc in old_contacts
			c=Contact.new
			c.id = oc.id
			c.site_id = 1
			c.email = oc.email
			c.subject = oc.subject
			c.ip = oc.ip
			c.crash_id = oc.crash_id
			c.content = oc.content
			c.created_at = oc.created_at
			c.updated_at = oc.updated_at
			c.save
		end
	end
	
	def migrate_coupons
		#None to migrate
	end
	
	def migrate_crashes
		old_crashes = V15Crash.find(:all)
		for oc in old_crashes
			c = Crash.new
			c = oc
			c.save
		end
	end
	
	def migrate_email_messages
		#None to migrate
	end
	
	def migrate_email_subscriptions
		#Need to migrate all email addresses to the users table first, if they are unique.
		
		
		old_subsciptions = V15EmailSubscription.find(:all)
		for os in old_subscriptions
			e = EmailSubscribing.new
			e.id = os.id

				
		end
	end
	
	
end
