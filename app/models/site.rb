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
			tmp_name = model.split(/_/)
			model_name = ''
			tmp_name.each do |a|
				model_name = model_name + a.capitalize
			end
			model_def = <<EOS
class V15#{model_name} < ActiveRecord::Base
end
EOS
			model_path = base_model_filepath + 'v15_' + model + '.rb'
			File.open(model_path, 'w') {|f| f.write(model_def) }

		end
	end

	def migrate_models
		self.migrate_users
		self.migrate_authors
		self.migrate_articles
		self.migrate_backings
		self.migrate_backing_events
		self.migrate_badges
		self.migrate_badgings
		self.migrate_books
		self.migrate_comments
		self.migrate_contacts
		self.migrate_coupons
		self.migrate_email_subscriptions
		self.migrate_episodes
		self.migrate_follows
		self.migrate_genres
		self.migrate_geo_states
		self.migrate_links
		self.migrate_merchandises
		self.migrate_messages
		self.migrate_openids
		self.migrate_orders
		self.migrate_order_transactions
		self.migrate_podcasts
		self.migrate_posts
		#self.migrate_raw_backing_events
		#self.migrate_raw_stats
		self.migrate_redemptions
		self.migrate_reviews
		self.migrate_static_pages
		self.migrate_subscription_types
	end

	def migrate_files
		self.migrate_book_assets
		self.migrate_book_covers
		self.migrate_user_photos
		self.migrate_episode_audio
	end

	def migrate_book_assets                
		old_dir = "#{Rails.root}/tmp/assets_old"
		book_ids = Dir.entries( old_dir )
		valid_formats = ['epub','mobi','pdf','doc','docx','rtf','txt','odt']
		for id in book_ids
			if id.to_i > 0 
				book = Book.find id
				files = Dir.entries("#{old_dir}/#{id}")
				for file in files
					ext = file.split(/\./).last
					if valid_formats.include?(ext)
						#Create asset record for the file
						asset = Asset.new
						asset.book_id = book.id
						asset.title = book.title
						asset.format = ext
						asset.price = V15Book.find( book.id ).price
						asset.asset_type = 'full work'
						asset.origin = 'migration from v1.5'
						asset.status = 'published'
						asset.save

						#Create attachment
						attachment=Attachment.new
						attachment.owner = book.author
						attachment.attachment_type = 'content_file'
						attachment.name = book.title
						attachment.format = ext
						attachment.path = "#{PRIVATE_ATTACHMENT_PATH}/Assets/#{asset.id}/content_files/"
						create_directory( attachment.path ) unless File.directory? attachment.path
						FileUtils.cp("#{old_dir}/#{id}/#{file}", "#{attachment.path}#{book.title}.#{ext}")
						attachment.save
					end
				end
			end
		end
	end

	def migrate_book_covers
		old_dir = "#{Rails.root}/tmp/system_old/cover_arts"
		book_ids = Dir.entries( old_dir )
		valid_formats = ['jpg','gif','png','jpeg','bmp']
		for id in book_ids
			if id.to_i > 0
				book=Book.find id
				original_filename = Dir.entries("#{old_dir}/#{id}/original").last
				original_name = original_filename.split(/\./).first
				original_format = original_filename.split(/\./).last
				original_filepath = "#{old_dir}/#{id}/original/#{original_filename}"
				output_dir = "#{PUBLIC_ATTACHMENT_PATH}/Books/#{id}/avatars/"
				if !original_format.nil? and valid_formats.include?( original_format.downcase )
					create_directory( output_dir ) unless File.directory? output_dir
					styles = { :profile => "233", :thumb => "100", :tiny => "40"}
					for style_name, style_detail in styles
						output_filename = "#{output_dir}#{original_name}_#{style_name}.#{original_format}"
						image = MiniMagick::Image.open( original_filepath )
						image.resize style_detail
						image.write output_filename

						attachment=Attachment.new
						attachment.owner = book
						attachment.attachment_type = 'avatar'
						attachment.name = "#{original_name}_#{style_name}"
						attachment.format = original_format
						attachment.path = output_dir
						status = attachment.save
						puts "Cover Art saved = #{status} Name = #{attachment.name} Owner_id = #{attachment.owner_id} Owner_type = #{attachment.owner_type}\n"
					end
				end
			end
		end
	end

	def migrate_user_photos
		old_dir = "#{Rails.root}/tmp/system_old/photos"
		user_ids = Dir.entries( old_dir )
		valid_formats = ['jpg','gif','png','jpeg','bmp']
		for id in user_ids
			if id.to_i > 0
				user=User.find id
				original_filename = Dir.entries("#{old_dir}/#{id}/original").last
				original_name = original_filename.split(/\./).first
				original_format = original_filename.split(/\./).last
				original_filepath = "#{old_dir}/#{id}/original/#{original_filename}"
				output_dir = "#{PUBLIC_ATTACHMENT_PATH}/Users/#{id}/avatars/"
				if !original_format.nil? and valid_formats.include?( original_format.downcase)
					create_directory( output_dir ) unless File.directory? output_dir
					styles = { :profile => "120", :thumb => "64", :tiny => "20"}
					styles.each_pair  {|style_name, style_detail| 
						puts "ID = #{id} name = #{style_name} key = #{style_detail}"

						output_filename = "#{output_dir}#{original_name}_#{style_name}.#{original_format}"
						image = MiniMagick::Image.open( original_filepath )
						image.resize style_detail
						image.write output_filename

						attachment = Attachment.new
						attachment.owner = user
						attachment.attachment_type = 'avatar'
						attachment.name = "#{original_name}_#{style_name}"
						attachment.format = original_format
						attachment.path = output_dir
						attachment.save
					}
				end
			end
		end
	end


	def migrate_episode_audio
		old_dir = "#{Rails.root}/tmp/system_old/audio/podcasts/1"
		episode_ids = Dir.entries( old_dir )
		valid_formats = ['mp3']
		for id in episode_ids
			if id.to_i > 0
				episode=Episode.find id
				original_filename = Dir.entries("#{old_dir}/#{id}").last
				original_name = original_filename.split(/\./).first
				original_format = original_filename.split(/\./).last
				original_filepath = "#{old_dir}/#{id}/#{original_filename}"
				output_dir = "#{PUBLIC_ATTACHMENT_PATH}/Episodes/#{id}/audio/"
				if !original_format.nil? and valid_formats.include?( original_format.downcase )
					create_directory( output_dir ) unless File.directory? output_dir
					FileUtils.cp(original_filepath, "#{output_dir}/#{original_name}")

					attachment=Attachment.new
					attachment.owner = episode
					attachment.attachment_type = 'audio'
					attachment.name = original_name
					attachment.format = original_format
					attachment.path = output_dir
					status = attachment.save
					puts "Episode saved = #{status} Name = #{attachment.name} Owner_id = #{attachment.owner_id} Owner_type = #{attachment.owner_type}\n"
				end
			end
		end
	end


	def migrate_users
		# Migrate the has attachments
		old_users = V15User.all
		for old_user in old_users
			puts "User ID = #{old_user.id} \n"
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
		u1 = User.find 1
		u2 = User.find 2
		u2.name = 'Old Anonymous'
		u2.save( false )
		u1.name = 'Anonymous'
		u1.email = 'anonymous@backmybook.com'
		u1.save( false )
		u2.update_attributes :name => 'Old Anonymous'
		u1.update_attributes :name => 'Anonymous', :email => 'anonymous@backmybook.com'

	end

	def migrate_authors
		# Has attachments
		old_authors = V15Author.all
		for ao in old_authors
			puts "Author ID = #{ao.id} \n"
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
		old_articles = V15Article.all
		for ao in old_articles
			puts "Article ID = #{ao.id} \n"
			a=Article.new
			a.id = ao.id
			if ao.author_id.nil?
				a.owner_id = 1
				a.owner_type = 'Site'
			else 
				a.owner_id = ao.author_id
				a.owner_type = 'Author'
			end
			a.title = ao.title
			a.excerpt = ao.description
			a.snip_at = ao.snip_at
			a.view_count = ao.view_count
			a.content = ao.content
			a.status = ao.availability
			a.publish_at = ao.created_at
			a.save
		end	
	end

	def migrate_backings
		old_backings = V15Backing.all
		for ob in old_backings
			puts "Backing ID = #{ob.id} \n"
			b=Backing.new
			b.id = ob.id
			b.user_id = ob.user_id
			b.book_id = ob.book_id
			b.points = ob.points
			b.created_at = ob.created_at
			b.updated_at = ob.updated_at
			b.save
		end
	end

	def migrate_backing_events
		old_backings = V15BackingEvent.all
		for ob in old_backings
			puts "Backing Event ID = #{ob.id} \n"
			b=BackingEvent.new
			b.id = ob.id
			b.backing_id = ob.backing_id
			b.event_type = ob.event_type
			b.url = ob.url
			b.ip = ob.ip
			b.points = ob.points
			b.created_at = ob.created_at
			b.updated_at = ob.updated_at
			b.save
		end
	end

	def migrate_badges
		# Has attachments
		old_badges = V15Badge.all
		for ob in old_badges
			puts "Badge ID = #{ob.id} \n"
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
		old_badgings = V15Badging.all
		for ob in old_badgings
			puts "Badging ID = #{ob.id} \n"
			b=Badging.new
			b.id = ob.id
			b.badge_id = ob.badge_id
			b.badgeable_id = ob.user_id
			b.badgeable_type = 'User'
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
		old_books = V15Book.all
		for ob in old_books
			puts "Book ID = #{ob.id} \n"
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
		old_comments = V15Comment.all
		for oc in old_comments
			puts "Comment ID = #{oc.id} \n"
			c=Comment.new
			c.id = oc.id
			c.user_id = oc.user_id
			c.commentable_type = oc.commentable_type
			c.commentable_id = oc.commentable_id
			c.ip = oc.ip
			c.content = oc.content
			c.created_at = oc.created_at
			c.updated_at = oc.updated_at
			c.save
		end
	end

	def migrate_contacts
		old_contacts = V15Contact.all
		for oc in old_contacts
			puts "Contact ID = #{oc.id} \n"
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
		old_crashes = V15Crash.all
		for oc in old_crashes
			puts "Crash ID = #{oc.id} \n"
			c = Crash.new
			c.site_id = 1
			c.message = oc.message
			c.requested_url = oc.requested_url
			c.referrer = oc.referrer
			c.backtrace = oc.backtrace
			c.created_at = oc.created_at
			c.updated_at = oc.updated_at
			c.save
		end
	end

	def migrate_email_messages
		#None to migrate
	end

	def migrate_email_subscriptions
		old_subscriptions = V15EmailSubscription.all
		for os in old_subscriptions
			puts "Subscription ID = #{os.id} \n"
			if os.user_id		
				user = User.find os.user_id 
			else				
				# Look for the user by email, and if he's not found, create him
				if !User.find_by_email( os.email )
					user = User.new
					user.email = os.email
					os.name ? user.name = os.name : user.name = os.email
					user.save( false ) 
				else
					user = User.find_by_email( os.email )
				end
			end

			sub = EmailSubscribing.new

			if os.author_id.nil?
				sub.subscribed_to_id = 1
				sub.subscribed_to_type = 'Site'
				sub.subscriber_id = user.id
				sub.subscriber_type = 'User'
			else
				sub.subscribed_to_id = os.author_id
				sub.subscribed_to_type = 'Author'
				os.user_id ? sub.subscriber_id = user.id : sub.subscriber_id = user.id
				sub.subscriber_type = 'User'
			end	

			sub.unsubscribe_code = os.unsubscribe_code
			sub.status = os.status
			sub.created_at = os.created_at
			sub.updated_at = os.updated_at
			sub.save
		end
	end

	def migrate_episodes
		old_episodes = V15Episode.all
		for oe in old_episodes
			puts "Episode ID = #{oe.id} \n"
			e = Episode.new
			e.id = oe.id
			e.podcast_id = oe.podcast_id
			e.status = oe.status
			e.title = oe.title
			e.subtitle = oe.subtitle
			e.keywords = oe.keywords
			e.duration = oe.duration
			e.description = oe.summary
			e.explicit = oe.explicit
			e.transcript = oe.transcript
			e.created_at = oe.created_at
			e.updated_at = oe.updated_at
			e.save
		end
	end

	def migrate_follows
		#TODO Check and see what follow_type means
		old_follows = V15Follow.all
		for of in old_follows
			puts "Follow ID= #{of.id} \n"
			f = Follow.new
			f.id = of.id
			f.followed_id = of.followable_id
			f.followed_type = of.followable_type
			f.follower_id = of.follower_id
			f.follower_type = of.follower_type
			f.created_at = of.created_at
			f.updated_at = of.updated_at
			f.save
		end
	end

	def migrate_forums
		old_forums = V15Forum.all
		for of in old_forums
			puts "Forum ID = #{of.id} \n"
			f = Forum.new
			f.id = of.id
			if of.author_id.nil?
				f.owner_id = 1
				f.owner_type = 'Site'
			else
				f.owner_id = of.author_id
				f.owner_type = 'Author'
			end
			f.title = of.name
			f.availability = of.availability
			f.description = of.description
			f.created_at = of.created_at
			f.updated_at = of.updated_at
			f.save			
		end
	end


	def migrate_genres
		old_genres = V15Genre.all
		for og in old_genres
			puts "Genre ID = #{og.id} \n"
			g = Genre.new
			g.id = og.id
			g.name = og.name
			g.parent_id = og.parent_id
			g.description = og.desc
			g.created_at = og.created_at
			g.updated_at = og.updated_at
			g.save
		end
	end

	def migrate_geo_states
		old_geo_states = V15GeoState.all
		for og in old_geo_states
			puts "State ID = #{og.id} \n"
			g = GeoState.new
			g.id = og.id
			g.name = og.name
			g.abbrev = og.abbrev
			g.country = og.country
			g.created_at = og.created_at
			g.updated_at = og.updated_at
			g.save
		end
	end

	def migrate_giveaways
		# This will have to be custom coded for each type of legacy giveaway according to the giveaway rules since bundles are introduced in the new model structure
	end

	def migrate_links
		old_links = V15Link.all
		for ol in old_links
			puts "Link ID = #{ol.id} \n"
			l = Link.new
			l.id = ol.id
			l.owner_id = ol.owner_id
			l.owner_type = ol.owner_type
			l.title = ol.title
			l.url = ol.url
			l.description = ol.description
			l.link_type = ol.link_type
			l.created_at = ol.created_at
			l.updated_at = ol.updated_at
			l.save
		end
	end

	def migrate_merchandises
		old_merch = V15Merchandise.all
		for om in old_merch
			puts "Merchandise ID = #{om.od} \n"
			m = Merch.new
			m.id = om.id
			m.owner_id = om.author_id
			m.owner_type = 'Author'
			m.title = om.title
			m.description = om.long_desc
			m.price = om.price
			m.status = om.status
			m.created_at = om.created_at
			m.updated_at = om.updated_at
			m.save
		end
	end

	def migrate_messages
		old_messages = V15Message.all
		for om in old_messages
			puts "Message ID = #{om.id} \n"
			m = Message.new
			m.id = om.id
			m.to_id = om.to_user
			m.to_type = 'User'
			m.from_id = m.from_user
			m.from_type = 'User'
			m.title = om.subject
			m.content = om.content
			m.created_at = om.created_at
			m.updated_at = om.updated_at
			m.save
		end
	end

	def migrate_openids
		old_ids = V15Openid.all
		for oo in old_ids
			puts "Open ID = #{oo.id} \n"
			o = Openid.new
			o.id = oo.id
			o.user_id = oo.user_id
			o.identifier = oo.identifier
			o.name = oo.name
			o.provider = oo.provider
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_orders
		old_orders = V15Order.all
		for oo in old_orders
			puts "Order ID = #{oo.id} \n"
			#migrate shipping and billing addresses if available
			user = V15User.find oo.user_id
			unless user.street.nil? 
				bill_addy = BillingAddress.new
				bill_addy.user_id = user.id
				bill_addy.first_name = user.fname
				bill_addy.last_name = user.lname

				bill_addy.street = user.street
				bill_addy.street2 = user.street2
				bill_addy.city = user.city
				bill_addy.geo_state_id = user.geo_state_id
				bill_addy.zip = user.zip
				bill_addy.country = 'US'
				bill_addy.phone = user.phone
				bill_addy.save
			end

			unless oo.ship_street.nil?
				ship_addy = ShippingAddress.new
				ship_addy.user_id = user.id
				ship_addy.first_name = user.fname
				ship_addy.last_name = user.lname
				ship_addy.street = oo.ship_street
				ship_addy.city = oo.ship_city
				ship_addy.geo_state_id = oo.ship_geo_state_id
				ship_addy.zip = oo.ship_zip
				ship_addy.first_name = oo.ship_name.split(/ /).first
				ship_addy.last_name = oo.ship_name.split(/ /).last
				ship_addy.save
			end

			o = Order.new
			o.id = oo.id
			o.user_id = oo.user_id
			o.shipping_address_id = ShippingAddress.find_by_street( oo.ship_street).id unless oo.ship_street.nil?
			o.billing_address_id = BillingAddress.find_by_street( user.street ).id unless user.street.nil?
			o.ordered_id = oo.item_id
			o.ordered_type = oo.item_type
			o.ip = oo.ip_address
			o.price = oo.price_in_cents
			o.status = oo.status
			o.paypal_express_token = oo.paypal_express_token
			o.paypal_express_payer_id = oo.paypal_express_payer_id
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save( false )

		end
	end

	def migrate_order_transactions
		old_txn = V15OrderTransaction.all
		for oo in old_txn
			puts "Order Transaction ID = #{oo.id} \n"
			o = OrderTransaction.new
			o.id = oo.id
			o.order_id = oo.order_id
			o.price = oo.price_in_cents
			o.message = oo.message
			o.reference = oo.reference
			o.action = oo.action
			o.params = oo.params
			o.success = oo.success
			o.test = oo.test
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_podcasts
		old_podcasts = V15Podcast.all
		for op in old_podcasts
			puts "Podcast ID = #{op.id} \n"
			o = Podcast.new
			if op.author_id.nil?
				o.owner_id = 1
				o.owner_type = 'Site'
			else
				o.owner_id = op.author_id
				o.owner_type = 'Author'
			end
			o.title = op.title
			o.subtitle = op.subtitle
			o.description = op.summary
			o.duration = op.duration
			o.keywords = op.keywords
			o.explicit = op.explicit
			o.itunes_id = op.itunes_id
			o.created_at = op.created_at
			o.updated_at = op.updated_at
			o.save
		end
	end

	def migrate_posts
		old_posts = V15Post.all
		for op in old_posts
			puts "Post ID = #{op.id} \n"
			o = Post.new
			o.id = op.id
			o.type = op.type
			o.forum_id = op.forum_id
			o.topic_id = op.topic_id
			o.reply_to_post_id = op.reply_to
			o.user_id = op.user_id
			o.title = op.title
			o.content = op.content
			o.view_count = op.view_count
			o.ip = op.ip
			o.created_at = op.created_at
			o.updated_at = op.updated_at
			o.save
		end
	end	

	def migrate_raw_backing_events
		old_raws = V15RawBackingEvent.all
		for oo in old_raws
			puts "Raw Backing Event ID = #{oo.id} \n"
			o = RawBackingEvent.new
			o.id = oo.id
			o.backing_id = oo.backing_id
			o.backing_event_id = oo.backing_event_id
			o.event_type = oo.event_type
			o.url = oo.url
			o.ip = oo.ip
			o.points = oo.points
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at 
			o.save
		end
	end

	def migrate_raw_stats
		old_stats = V15RawStat.all
		for oo in old_stats
			puts "Raw Stat ID = #{oo.id} \n"
			o = RawStat.new
			o.id = oo.id
			o.name = oo.name
			o.statable_id = oo.statable_id
			o.statable_type = oo.statable_type
			o.ip = oo.ip
			o.count = oo.count
			o.extra_data = oo.extra_data
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at 
			o.save
		end
	end

	def migrate_readings
		old_readings = V15Reading.all
		for rr in old_readings
			puts "Readings ID = #{rr.id} \n"
			r = Reading.new
			r.id = rr.id
			r.book_id = rr.book_id
			r.user_id = rr.user_id
			r.page_number = rr.page_number
			r.created_at = rr.created_at
			r.updated_at = rr.updated_at
			r.save
		end
	end

	def migrate_redemptions
		old = V15Redemption.all
		for oo in old
			puts "Redemption ID = #{oo.id} \n"	
			o = Redemption.new
			o.id = oo.id
			o.redeemer_id = oo.redeemer_id
			o.redeemer_type = oo.redeemer_type
			o.coupon_id = oo.coupon_id
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_reviews
		old = V15Review.all
		for oo in old
			puts "Review ID = #{oo.id} \n"
			o = Review.new
			o.id = oo.id
			o.reviewable_id = oo.reviewable_id
			o.reviewable_type = oo.reviewable_type
			o.user_id = oo.user_id
			o.score = oo.score
			o.content = oo.content
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_static_pages
		old = V15StaticPage.all
		for oo in old
			puts "Static ID = #{oo.id} \n"
			o = StaticPage.new
			o.id = oo.id
			o.site_id = 1
			o.title = oo.title
			o.description = oo.description
			o.permalink = oo.permalink
			o.content = oo.content
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_subscription_types
		old = V15SubscriptionType.all
		for oo in old
			puts "Subscription Type ID = #{oo.id} \n"
			o = Subscription.new
			o.owner_id = 1
			o.owner_type = 'Site'
			o.title = oo.name
			o.description = oo.description
			o.periodicity = oo.periodicity
			o.price = oo.price
			o.monthly_email_limit = oo.monthly_email_limit
			oo.redemptions_remaining.nil? ? o.redemptions_remaining = -1 : o.redemptions_remaining = oo.redemptions_remaining
			o.subscription_length_in_days = oo.subscription_length_in_days
			o.royalty_percentage = 90
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

	def migrate_subscriptions
		old = V15Subscription.all
		for oo in old
			puts "Subscription ID = #{oo.id} \n"
			o = Subscribing.new
			o.subscription_id = oo.subscription_type_id
			o.user_id = oo.user_id
			o.order_id = oo.order_id
			o.status = oo.status
			o.profile_id = oo.profile_id
			o.expiration_date = oo.expiration_date
			o.origin = oo.origin
			o.created_at = oo.created_at
			o.updated_at = oo.updated_at
			o.save
		end
	end

end
