# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101103181324) do

  create_table "activities", :force => true do |t|
    t.integer  "actor_id",                            :null => false
    t.string   "actor_type",                          :null => false
    t.integer  "target_id",                           :null => false
    t.string   "target_type",                         :null => false
    t.string   "verb"
    t.string   "activity_type"
    t.string   "status",        :default => "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["actor_id", "actor_type"], :name => "fk_actor"
  add_index "activities", ["target_id", "target_type"], :name => "fk_target"

  create_table "articles", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.string   "excerpt"
    t.integer  "snip_at"
    t.integer  "view_count",       :default => 0
    t.text     "content"
    t.string   "status"
    t.boolean  "comments_allowed"
    t.datetime "publish_on"
    t.string   "article_type"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["cached_slug"], :name => "index_articles_on_cached_slug", :unique => true
  add_index "articles", ["owner_id"], :name => "index_articles_on_owner_id"

  create_table "assets", :force => true do |t|
    t.integer  "book_id"
    t.integer  "content_location_id"
    t.string   "title"
    t.string   "format"
    t.integer  "price"
    t.integer  "download_count",      :default => 0
    t.string   "asset_type"
    t.integer  "word_count"
    t.string   "origin"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "featured_book_id"
    t.string   "pen_name"
    t.string   "subdomain"
    t.string   "domain"
    t.text     "bio"
    t.integer  "score"
    t.string   "cached_slug"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "photo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backing_events", :force => true do |t|
    t.integer  "backing_id"
    t.string   "event_type"
    t.string   "url"
    t.string   "ip"
    t.integer  "points",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "backings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "points",      :default => 0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badges", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.string   "badge_type"
    t.string   "description"
    t.integer  "level"
    t.string   "artwork_file_name"
    t.string   "artwork_content_type"
    t.integer  "artwork_file_size"
    t.datetime "artwork_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badgings", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "badgeable_id"
    t.string   "badgeable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "book_identifiers", :force => true do |t|
    t.integer  "book_id_id"
    t.string   "identifier_type"
    t.string   "identifier"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.integer  "author_id"
    t.integer  "genre_id"
    t.string   "title"
    t.integer  "view_count",             :default => 0
    t.integer  "score"
    t.string   "subtitle"
    t.text     "description"
    t.string   "status"
    t.string   "age_aprop"
    t.float    "rating_average"
    t.string   "backing_url"
    t.string   "cached_slug"
    t.string   "cover_art_url"
    t.string   "cover_art_file_name"
    t.string   "cover_art_content_type"
    t.integer  "cover_art_file_size"
    t.datetime "cover_art_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bundle_assets", :force => true do |t|
    t.integer  "bundle_id"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bundles", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.text     "description"
    t.integer  "price"
    t.string   "artwork_url"
    t.string   "artwork_file_name"
    t.string   "artwork_content_type"
    t.integer  "artwork_file_size"
    t.datetime "artwork_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "reply_to_comment_id"
    t.string   "ip"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["reply_to_comment_id"], :name => "index_comments_on_reply_to_comment_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.integer  "site_id"
    t.string   "email"
    t.string   "subject"
    t.string   "ip"
    t.integer  "crash_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["crash_id"], :name => "index_contacts_on_crash_id"
  add_index "contacts", ["email"], :name => "index_contacts_on_email"

  create_table "content_locations", :force => true do |t|
    t.integer  "asset_id"
    t.string   "path"
    t.text     "content",    :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "redeemable_id"
    t.string   "redeemable_type"
    t.integer  "redeemer_id"
    t.string   "redeemer_type"
    t.string   "code"
    t.string   "description"
    t.datetime "expiration_date"
    t.integer  "redemptions_allowed", :default => -1
    t.string   "discount_type"
    t.integer  "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "crashes", :force => true do |t|
    t.integer  "site_id"
    t.string   "message"
    t.string   "requested_url"
    t.string   "referrer"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_campaigns", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "email_template_id"
    t.string   "title"
    t.string   "status"
    t.string   "campaign_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_deliveries", :force => true do |t|
    t.integer  "email_subscribing_id"
    t.integer  "email_message_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_messages", :force => true do |t|
    t.integer  "email_campaign_id"
    t.string   "subject"
    t.text     "content"
    t.datetime "deliver_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_subscribings", :force => true do |t|
    t.integer  "subscribed_to_id"
    t.string   "subscribed_to_type"
    t.integer  "subscriber_id"
    t.string   "subscriber_type"
    t.string   "unsubscribe_code"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", :force => true do |t|
    t.integer  "podcast_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "keywords"
    t.string   "duration"
    t.text     "description"
    t.integer  "filesize"
    t.string   "filename"
    t.string   "explicit"
    t.text     "transcript"
    t.string   "status"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["podcast_id"], :name => "index_episodes_on_podcast_id"
  add_index "episodes", ["title"], :name => "index_episodes_on_title"

  create_table "events", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.string   "event_type"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "facebook_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "name"
    t.string   "fb_id"
    t.string   "fb_token"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_accounts", ["owner_id"], :name => "index_facebook_accounts_on_owner_id"

  create_table "facebook_pages", :force => true do |t|
    t.integer  "facebook_account_id"
    t.string   "name"
    t.string   "page_type"
    t.string   "fb_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "facebook_pages", ["facebook_account_id"], :name => "index_facebook_pages_on_facebook_account_id"

  create_table "follows", :force => true do |t|
    t.integer  "followed_id",                         :null => false
    t.string   "followed_type",                       :null => false
    t.integer  "follower_id",                         :null => false
    t.string   "follower_type",                       :null => false
    t.string   "status",        :default => "active"
    t.string   "follow_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followed_id", "followed_type"], :name => "fk_followed"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "forums", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.string   "availability"
    t.string   "description"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "forums", ["cached_slug"], :name => "index_forums_on_cached_slug", :unique => true
  add_index "forums", ["owner_id"], :name => "index_forums_on_owner_id"

  create_table "genres", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "description"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_addresses", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.integer  "geo_state_id"
    t.string   "zip"
    t.string   "country"
    t.string   "phone"
    t.boolean  "preferred",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "geo_states", :force => true do |t|
    t.string   "name"
    t.string   "abbrev"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "links", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.string   "url"
    t.string   "description"
    t.string   "link_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merches", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.text     "description"
    t.integer  "inventory_count",      :default => -1
    t.integer  "price"
    t.string   "artwork_url"
    t.string   "artwork_file_name"
    t.string   "artwork_content_type"
    t.integer  "artwork_file_size"
    t.datetime "artwork_updated_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.integer  "to_id"
    t.string   "to_type"
    t.integer  "from_id"
    t.string   "from_type"
    t.string   "title"
    t.text     "content"
    t.datetime "deliver_at"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "openids", :force => true do |t|
    t.integer  "user_id"
    t.string   "identifier"
    t.string   "name"
    t.string   "provider"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "openids", ["user_id"], :name => "index_openids_on_user_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.integer  "price"
    t.string   "message"
    t.string   "reference"
    t.string   "action"
    t.text     "params"
    t.boolean  "success"
    t.boolean  "test"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "user_id"
    t.integer  "shipping_address_id"
    t.integer  "billing_address_id"
    t.integer  "ordered_id"
    t.string   "ordered_type"
    t.string   "email"
    t.string   "ip"
    t.integer  "price"
    t.string   "status"
    t.string   "paypal_express_token"
    t.string   "paypal_express_payer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ownings", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "user_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "podcasts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "itunes_id"
    t.text     "description"
    t.string   "duration"
    t.string   "filename"
    t.string   "keywords"
    t.integer  "filesize"
    t.string   "explicit"
    t.string   "status"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "podcasts", ["owner_id"], :name => "index_podcasts_on_owner_id"
  add_index "podcasts", ["title"], :name => "index_podcasts_on_title"

  create_table "posts", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "topic_id"
    t.integer  "reply_to_post_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.integer  "view_count",       :default => 0
    t.string   "ip"
    t.string   "type"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["cached_slug"], :name => "index_posts_on_cached_slug", :unique => true
  add_index "posts", ["forum_id"], :name => "index_posts_on_forum_id"
  add_index "posts", ["reply_to_post_id"], :name => "index_posts_on_reply_to_post_id"
  add_index "posts", ["topic_id"], :name => "index_posts_on_topic_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "raw_backing_events", :force => true do |t|
    t.integer  "backing_id"
    t.integer  "backing_event_id"
    t.string   "event_type"
    t.string   "url"
    t.string   "ip"
    t.integer  "points",           :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_stat_events", :force => true do |t|
    t.integer  "statable_id"
    t.string   "statable_type"
    t.string   "name"
    t.string   "ip"
    t.integer  "count",         :default => 0
    t.string   "extra_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "raw_stats", :force => true do |t|
    t.integer  "statable_id"
    t.string   "statable_type"
    t.string   "name"
    t.string   "ip"
    t.integer  "count",         :default => 0
    t.string   "extra_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "raw_stats", ["statable_id"], :name => "index_raw_stats_on_statable_id"

  create_table "readings", :force => true do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.integer  "page_number"
    t.string   "reading_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "redemptions", :force => true do |t|
    t.integer  "redeemer_id"
    t.string   "redeemer_type"
    t.integer  "coupon_id"
    t.integer  "order_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.integer  "user_id"
    t.integer  "score"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "site_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "royalties", :force => true do |t|
    t.integer  "author_id"
    t.integer  "order_id"
    t.integer  "amount"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["domain"], :name => "index_sites_on_domain"
  add_index "sites", ["owner_id"], :name => "index_sites_on_owner_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "stat_events", :force => true do |t|
    t.integer  "statable_id"
    t.string   "statable_type"
    t.string   "name"
    t.string   "ip"
    t.integer  "count",         :default => 0
    t.string   "extra_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", :force => true do |t|
    t.integer  "site_id"
    t.string   "title"
    t.string   "description"
    t.string   "permalink"
    t.string   "redirect_path"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "static_pages", ["permalink"], :name => "index_static_pages_on_permalink"
  add_index "static_pages", ["site_id"], :name => "index_static_pages_on_site_id"

  create_table "subscribings", :force => true do |t|
    t.integer  "subscription_id"
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "status"
    t.string   "profile_id"
    t.datetime "expiration_date"
    t.string   "origin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "title"
    t.string   "description"
    t.string   "periodicity"
    t.integer  "price"
    t.integer  "monthly_email_limit"
    t.integer  "redemptions_remaining"
    t.integer  "subscription_length_in_days"
    t.integer  "royalty_percentage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "themes", :force => true do |t|
    t.integer  "author_id"
    t.string   "bg_color"
    t.string   "text_color"
    t.string   "link_color"
    t.string   "bg_img_file_name"
    t.string   "bg_img_content_type"
    t.integer  "bg_img_file_size"
    t.datetime "bg_img_updated_at"
    t.string   "bg_repeat"
    t.string   "bg_img_url"
    t.string   "banner_img_file_name"
    t.string   "banner_img_content_type"
    t.integer  "banner_img_file_size"
    t.datetime "banner_img_updated_at"
    t.string   "banner_img_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "twitter_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "twit_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitter_accounts", ["owner_id"], :name => "index_twitter_accounts_on_owner_id"

  create_table "upload_email_lists", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "file_name"
    t.string   "file_path"
    t.string   "list_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.string   "title"
    t.string   "ext"
    t.string   "file_path"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "site_id"
    t.string   "email"
    t.string   "name"
    t.integer  "score",                                   :default => 0
    t.string   "website_name"
    t.string   "website_url"
    t.text     "bio"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "status",                                  :default => "first"
    t.string   "cached_slug"
    t.integer  "name_changes",                            :default => 3
    t.string   "tax_id"
    t.string   "orig_ip"
    t.string   "last_ip"
    t.string   "photo_url"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "paypal_id",                 :limit => 13
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["activation_code"], :name => "index_users_on_activation_code"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
