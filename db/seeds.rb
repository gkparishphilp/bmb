#Setup Default Admin and Anonymous Users
puts "Setup Default Anonymous User"

admin_role = Role.create(:name => 'admin')

anon = User.new :user_name => 'Anonymous', :photo_url => "/images/anon_user.jpg"

anon.save( false )
puts "Anon saved"

s = Site.create :name => 'todo'
