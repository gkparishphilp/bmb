#Setup Default Admin and Anonymous Users
puts "Setup Default Admin and Anonymous Users"

admin_role = Role.create(:name => 'admin')

admin = User.new :user_name => 'Admin', :photo_url => "/images/admin_user.jpg", 
					:email => "admin@todo.com", :password => "gs3_adm1n"

anon = User.new :user_name => 'Anonymous', :photo_url => "/images/anon_user.jpg", 
					:password => "an0n"

admin.roles << admin_role

admin.save
puts "Admin saved"
anon.save
puts "Anon saved"

s = Site.create :name => 'todo'
