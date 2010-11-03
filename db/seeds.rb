#Setup Default Admin and Anonymous Users
puts "Setup Default Anonymous User"

anon = User.new :name => 'Anonymous', :photo_url => "/images/anon_user.jpg"
anon.save( false )
puts "Anon saved"

puts "Setup Sites"
s = Site.create :domain => 'localhost', :name => 'BmB Dev'
s = Site.create :domain => 'tayandann.net', :name => 'BmB Facebook Dev'
s = Site.create :domain => 'backmybook.com', :name => 'BmB Deploy'
