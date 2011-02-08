class DbMigrationForEcom < ActiveRecord::Migration
  def self.up
	execute 'update articles set comments_allowed = 1'
	execute 'alter table articles alter comments_allowed set default 1'
	a=Author.find_by_pen_name('Scott Sigler')
	a.contact_email = 'scottsigler@backmybook.com'
	a.save
	
	drop_table :v15_articles            
	drop_table :v15_author_links        
	drop_table :v15_authors             
	drop_table :v15_backing_events      
	drop_table :v15_backings            
	drop_table :v15_badges              
	drop_table :v15_badgings            
	drop_table :v15_bkassets            
	drop_table :v15_bkcontents          
	drop_table :v15_bkfiles             
	drop_table :v15_books               
	drop_table :v15_comments            
	drop_table :v15_contacts            
	drop_table :v15_coupons             
	drop_table :v15_crashes             
	drop_table :v15_delayed_jobs        
	drop_table :v15_email_messages      
	drop_table :v15_email_subscriptions 
	drop_table :v15_email_templates     
	drop_table :v15_episodes            
	drop_table :v15_ereader_ownings     
	drop_table :v15_ereaders            
	drop_table :v15_facebook_templates  
	drop_table :v15_follows             
	drop_table :v15_forums              
	drop_table :v15_genres              
	drop_table :v15_genres_users        
	drop_table :v15_geo_states          
	drop_table :v15_giveaways           
	drop_table :v15_links               
	drop_table :v15_merchandises        
	drop_table :v15_messages            
	drop_table :v15_openids             
	drop_table :v15_order_transactions  
	drop_table :v15_orders              
	drop_table :v15_pages               
	drop_table :v15_pfeed_deliveries    
	drop_table :v15_pfeed_items         
	drop_table :v15_podcasts            
	drop_table :v15_posts               
	drop_table :v15_raw_backing_events  
	drop_table :v15_raw_stats           
	drop_table :v15_readings            
	drop_table :v15_redemptions         
	drop_table :v15_reviews             
	drop_table :v15_roles               
	drop_table :v15_roles_users         
	drop_table :v15_schema_migrations   
	drop_table :v15_sites               
	drop_table :v15_slugs               
	drop_table :v15_static_pages        
	drop_table :v15_subscription_types  
	drop_table :v15_subscriptions       
	drop_table :v15_taggings            
	drop_table :v15_tags                
	drop_table :v15_upload_email_lists  
	drop_table :v15_upload_files        
	drop_table :v15_users
  end

  def self.down
  end
end
