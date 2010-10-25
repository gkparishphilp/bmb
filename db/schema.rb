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

ActiveRecord::Schema.define(:version => 20101025171002) do

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
    t.string   "name"
    t.string   "format"
    t.integer  "price"
    t.integer  "download_count",      :default => 0
    t.string   "asset_type"
    t.integer  "word_count"
    t.string   "origin"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "pen_name"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "book_identifiers", :force => true do |t|
    t.integer  "book_id"
    t.string   "identifier_type"
    t.string   "identifier"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.integer  "author_id"
    t.integer  "genre_id"
    t.integer  "view_count",     :default => 0
    t.string   "subtitle"
    t.text     "description"
    t.string   "status"
    t.string   "age_aprop"
    t.float    "rating_average"
    t.string   "backing_url"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "reply_to_comment_id"
    t.string   "name"
    t.string   "email"
    t.string   "website_name"
    t.string   "website_url"
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

  create_table "crashes", :force => true do |t|
    t.string   "message"
    t.string   "requested_url"
    t.string   "referrer"
    t.text     "backtrace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes", :force => true do |t|
    t.integer  "podcast_id"
    t.string   "status"
    t.string   "title"
    t.string   "subtitle"
    t.string   "keywords"
    t.string   "duration"
    t.text     "description"
    t.integer  "filesize"
    t.string   "filename"
    t.string   "explicit"
    t.text     "transcript"
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "episodes", ["podcast_id"], :name => "index_episodes_on_podcast_id"
  add_index "episodes", ["title"], :name => "index_episodes_on_title"

  create_table "fb_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "email_hash"
    t.string   "fb_name"
    t.string   "fb_session_key"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "fb_user_id",     :limit => 8
  end

  add_index "fb_accounts", ["email_hash"], :name => "index_fb_accounts_on_email_hash"
  add_index "fb_accounts", ["owner_id"], :name => "index_fb_accounts_on_owner_id"

  create_table "forums", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
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

  add_index "links", ["owner_id"], :name => "index_links_on_owner_id"

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

  create_table "podcasts", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "owner_type"
    t.string   "title"
    t.string   "subtitle"
    t.string   "itunes_id"
    t.text     "description"
    t.string   "duration"
    t.string   "filename"
    t.string   "keywords"
    t.integer  "filesize"
    t.string   "explicit"
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

  create_table "raw_stats", :force => true do |t|
    t.string   "name"
    t.integer  "statable_id"
    t.string   "statable_type"
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
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "twitter_accounts", :force => true do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "token"
    t.string   "secret"
    t.string   "twit_name"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "twit_id",    :limit => 8
  end

  add_index "twitter_accounts", ["owner_id"], :name => "index_twitter_accounts_on_owner_id"

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
    t.string   "user_name"
    t.integer  "score",                                   :default => 0
    t.string   "website_name"
    t.string   "website_url"
    t.string   "hashed_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "status"
    t.string   "cached_slug"
    t.integer  "name_changes",                            :default => 3
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "geo_state_id"
    t.string   "zip"
    t.string   "ssn"
    t.string   "phone"
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
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

end
