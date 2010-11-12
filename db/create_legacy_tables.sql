create table bmb_dev.v15_articles 			 like bmb_v15.articles;  
INSERT INTO bmb_dev.v15_articles SELECT * FROM bmb_v15.articles;         

create table bmb_dev.v15_author_links 		 like bmb_v15.author_links;      
INSERT INTO bmb_dev.v15_author_links SELECT * FROM bmb_v15.author_links;         

create table bmb_dev.v15_authors 			 like bmb_v15.authors;           
INSERT INTO bmb_dev.v15_authors SELECT * FROM bmb_v15.authors;         

create table bmb_dev.v15_backing_events 	 like bmb_v15.backing_events;     
INSERT INTO bmb_dev.v15_backing_events SELECT * FROM bmb_v15.backing_events;         

create table bmb_dev.v15_backings 			 like bmb_v15.backings;         
INSERT INTO bmb_dev.v15_backings SELECT * FROM bmb_v15.backings;         

create table bmb_dev.v15_badges 			 like bmb_v15.badges;            
INSERT INTO bmb_dev.v15_badges SELECT * FROM bmb_v15.badges;         

create table bmb_dev.v15_badgings 			 like bmb_v15.badgings;          
INSERT INTO bmb_dev.v15_badgings SELECT * FROM bmb_v15.badgings;         

create table bmb_dev.v15_bkassets 			 like bmb_v15.bkassets;          
INSERT INTO bmb_dev.v15_bkassets SELECT * FROM bmb_v15.bkassets;         

create table bmb_dev.v15_bkcontents 		 like bmb_v15.bkcontents;          
INSERT INTO bmb_dev.v15_bkcontents SELECT * FROM bmb_v15.bkcontents;         

create table bmb_dev.v15_bkfiles 			 like bmb_v15.bkfiles;            
INSERT INTO bmb_dev.v15_bkfiles SELECT * FROM bmb_v15.bkfiles;         

create table bmb_dev.v15_books               like bmb_v15.books;
INSERT INTO bmb_dev.v15_books SELECT * FROM bmb_v15.books;         

create table bmb_dev.v15_comments            like bmb_v15.comments;
INSERT INTO bmb_dev.v15_comments SELECT * FROM bmb_v15.comments;         

create table bmb_dev.v15_contacts            like bmb_v15.contacts;
INSERT INTO bmb_dev.v15_contacts SELECT * FROM bmb_v15.contacts;         

create table bmb_dev.v15_coupons             like bmb_v15.coupons;
INSERT INTO bmb_dev.v15_coupons SELECT * FROM bmb_v15.coupons;         

create table bmb_dev.v15_crashes             like bmb_v15.crashes;
INSERT INTO bmb_dev.v15_crashes SELECT * FROM bmb_v15.crashes;         

create table bmb_dev.v15_delayed_jobs        like bmb_v15.delayed_jobs;
INSERT INTO bmb_dev.v15_delayed_jobs SELECT * FROM bmb_v15.delayed_jobs;         

create table bmb_dev.v15_email_messages      like bmb_v15.email_messages;
INSERT INTO bmb_dev.v15_email_messages SELECT * FROM bmb_v15.email_messages;         

create table bmb_dev.v15_email_subscriptions like bmb_v15.email_subscriptions;
INSERT INTO bmb_dev.v15_email_subscriptions SELECT * FROM bmb_v15.email_subscriptions;         

create table bmb_dev.v15_email_templates     like bmb_v15.email_templates;
INSERT INTO bmb_dev.v15_email_templates SELECT * FROM bmb_v15.email_templates;         

create table bmb_dev.v15_episodes            like bmb_v15.episodes;
INSERT INTO bmb_dev.v15_episodes SELECT * FROM bmb_v15.episodes;         

create table bmb_dev.v15_ereader_ownings     like bmb_v15.ereader_ownings;
INSERT INTO bmb_dev.v15_ereader_ownings SELECT * FROM bmb_v15.ereader_ownings;         

create table bmb_dev.v15_ereaders            like bmb_v15.ereaders;
INSERT INTO bmb_dev.v15_ereaders SELECT * FROM bmb_v15.ereaders;         

create table bmb_dev.v15_facebook_templates  like bmb_v15.facebook_templates;
INSERT INTO bmb_dev.v15_facebook_templates SELECT * FROM bmb_v15.facebook_templates;         

create table bmb_dev.v15_follows             like bmb_v15.follows;
INSERT INTO bmb_dev.v15_follows SELECT * FROM bmb_v15.follows;         

create table bmb_dev.v15_forums              like bmb_v15.forums;
INSERT INTO bmb_dev.v15_forums SELECT * FROM bmb_v15.forums;         

create table bmb_dev.v15_genres              like bmb_v15.genres;
INSERT INTO bmb_dev.v15_genres SELECT * FROM bmb_v15.genres;         

create table bmb_dev.v15_genres_users        like bmb_v15.genres_users;
INSERT INTO bmb_dev.v15_genres_users SELECT * FROM bmb_v15.genres_users;         

create table bmb_dev.v15_geo_states          like bmb_v15.geo_states;
INSERT INTO bmb_dev.v15_geo_states SELECT * FROM bmb_v15.geo_states;         

create table bmb_dev.v15_giveaways           like bmb_v15.giveaways;
INSERT INTO bmb_dev.v15_giveaways SELECT * FROM bmb_v15.giveaways;         

create table bmb_dev.v15_links               like bmb_v15.links;
INSERT INTO bmb_dev.v15_links SELECT * FROM bmb_v15.links;         

create table bmb_dev.v15_merchandises        like bmb_v15.merchandises;
INSERT INTO bmb_dev.v15_merchandises SELECT * FROM bmb_v15.merchandises;         

create table bmb_dev.v15_messages            like bmb_v15.messages;
INSERT INTO bmb_dev.v15_messages SELECT * FROM bmb_v15.messages;         

create table bmb_dev.v15_openids             like bmb_v15.openids;
INSERT INTO bmb_dev.v15_openids SELECT * FROM bmb_v15.openids;         

create table bmb_dev.v15_order_transactions  like bmb_v15.order_transactions;
INSERT INTO bmb_dev.v15_order_transactions SELECT * FROM bmb_v15.order_transactions;         

create table bmb_dev.v15_orders              like bmb_v15.orders;
INSERT INTO bmb_dev.v15_orders SELECT * FROM bmb_v15.orders;         

create table bmb_dev.v15_pages               like bmb_v15.pages;
INSERT INTO bmb_dev.v15_pages SELECT * FROM bmb_v15.pages;         

create table bmb_dev.v15_pfeed_deliveries    like bmb_v15.pfeed_deliveries;
INSERT INTO bmb_dev.v15_pfeed_deliveries SELECT * FROM bmb_v15.pfeed_deliveries;         

create table bmb_dev.v15_pfeed_items         like bmb_v15.pfeed_items;
INSERT INTO bmb_dev.v15_pfeed_items SELECT * FROM bmb_v15.pfeed_items;         

create table bmb_dev.v15_podcasts            like bmb_v15.podcasts;
INSERT INTO bmb_dev.v15_podcasts SELECT * FROM bmb_v15.podcasts;         

create table bmb_dev.v15_posts               like bmb_v15.posts;
INSERT INTO bmb_dev.v15_posts SELECT * FROM bmb_v15.posts;         

create table bmb_dev.v15_raw_backing_events  like bmb_v15.raw_backing_events;
INSERT INTO bmb_dev.v15_raw_backing_events SELECT * FROM bmb_v15.raw_backing_events;         

create table bmb_dev.v15_raw_stats           like bmb_v15.raw_stats;
INSERT INTO bmb_dev.v15_raw_stats SELECT * FROM bmb_v15.raw_stats;         

create table bmb_dev.v15_readings            like bmb_v15.readings;
INSERT INTO bmb_dev.v15_readings SELECT * FROM bmb_v15.readings;         

create table bmb_dev.v15_redemptions         like bmb_v15.redemptions;
INSERT INTO bmb_dev.v15_redemptions SELECT * FROM bmb_v15.redemptions;         

create table bmb_dev.v15_reviews             like bmb_v15.reviews;
INSERT INTO bmb_dev.v15_reviews SELECT * FROM bmb_v15.reviews;         

create table bmb_dev.v15_roles               like bmb_v15.roles;
INSERT INTO bmb_dev.v15_roles SELECT * FROM bmb_v15.roles;         

create table bmb_dev.v15_roles_users         like bmb_v15.roles_users;
INSERT INTO bmb_dev.v15_roles_users SELECT * FROM bmb_v15.roles_users;         

create table bmb_dev.v15_schema_migrations   like bmb_v15.schema_migrations;
INSERT INTO bmb_dev.v15_schema_migrations SELECT * FROM bmb_v15.schema_migrations;         

create table bmb_dev.v15_sites               like bmb_v15.sites;
INSERT INTO bmb_dev.v15_sites SELECT * FROM bmb_v15.sites;         

create table bmb_dev.v15_slugs               like bmb_v15.slugs;
INSERT INTO bmb_dev.v15_slugs SELECT * FROM bmb_v15.slugs;         

create table bmb_dev.v15_static_pages        like bmb_v15.static_pages;
INSERT INTO bmb_dev.v15_static_pages SELECT * FROM bmb_v15.static_pages;         

create table bmb_dev.v15_subscription_types  like bmb_v15.subscription_types;
INSERT INTO bmb_dev.v15_subscription_types SELECT * FROM bmb_v15.subscription_types;         

create table bmb_dev.v15_subscriptions       like bmb_v15.subscriptions;
INSERT INTO bmb_dev.v15_subscriptions SELECT * FROM bmb_v15.subscriptions;         

create table bmb_dev.v15_taggings            like bmb_v15.taggings;
INSERT INTO bmb_dev.v15_taggings SELECT * FROM bmb_v15.taggings;         

create table bmb_dev.v15_tags                like bmb_v15.tags;
INSERT INTO bmb_dev.v15_tags SELECT * FROM bmb_v15.tags;         

create table bmb_dev.v15_upload_email_lists  like bmb_v15.upload_email_lists;
INSERT INTO bmb_dev.v15_upload_email_lists SELECT * FROM bmb_v15.upload_email_lists;         

create table bmb_dev.v15_upload_files		 like bmb_v15.upload_files;
INSERT INTO bmb_dev.v15_upload_files SELECT * FROM bmb_v15.upload_files;         

create table bmb_dev.v15_users                   like bmb_v15.users;
INSERT INTO bmb_dev.v15_users SELECT * FROM bmb_v15.users;         
