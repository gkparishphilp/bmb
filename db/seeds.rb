#Setup Default Admin and Anonymous Users
puts "Setup Default Anonymous User"

anon = User.new :name => 'Anonymous'
anon.save( false )
avatar = Attachment.create( :path => '/images/anon_user.jpg', :attachment_type => 'avatar', :owner => anon, :remote => true, :name => 'anon_user', :format => 'jpg' )
puts "Anon saved"

puts "Setup Dev Sites" # todo -- change and remove for prod
s = Site.create :domain => 'localhost', :name => 'BmB Dev'
s = Site.create :domain => 'tayandann.net', :name => 'BmB Facebook Dev'
s = Site.create :domain => 'backmybook.com', :name => 'BmB Deploy'
s = Site.create :domain => 'lvh.me', :name => 'Subdomain Testing'
s = Site.create :domain => 'rippleread.com', :name => 'Staging'

puts "How bout some default Themes?"
t = Theme.create :name => 'Easter Egg', :text_color => '#2b2a2b', :link_color => '#6aedfc', :hover_color => '#003fbd', :header_color => '#b835fa', :title_color => '#08f72c', :bg_color => '#ffff66', :banner_bg_color => '#8dfc93', :content_bg_color => '#ffbebe'

# Load Genres
puts "Load Genres"

f = Genre.create :name => 'Fiction'
n = Genre.create :name => 'Non Fiction'

g = f.children.create :name => "Action & Adventure"
g = f.children.create :name => "Children's"
g = f.children.create :name => "Drama"
g = f.children.create :name => "Fantasy"
g = f.children.create :name => "General Fiction"
g = f.children.create :name => "Horror"
g = f.children.create :name => "Literary Fiction"
g = f.children.create :name => "Mystery"
g = f.children.create :name => "Poetry"
g = f.children.create :name => "Romance"
g = f.children.create :name => "Science Fiction"
g = f.children.create :name => "Teen"
g = f.children.create :name => "Western"

g = n.children.create :name => "Arts"
g = n.children.create :name => "Business & Money"
g = n.children.create :name => "Computers"
g = n.children.create :name => "Food"
g = n.children.create :name => "Entertainment"
g = n.children.create :name => "General Non-Fiction"
g = n.children.create :name => "Health"
g = n.children.create :name => "History"
g = n.children.create :name => "Crafts"
g = n.children.create :name => "How to"
g = n.children.create :name => "Philosophy & Psych"
g = n.children.create :name => "Politics & Gov"
g = n.children.create :name => "Spirituality"
g = n.children.create :name => "Reference"
g = n.children.create :name => "Science & Nature"
g = n.children.create :name => "Self-Improvement"
g = n.children.create :name => "Sports & Leisure"
g = n.children.create :name => "Travel"

# load GeoStates
puts "Loading GeoStates..."

GeoState.create :country => 'US', :name => 'Alabama', :abbrev => 'AL'
GeoState.create :country => 'US', :name => 'Alaska', :abbrev => 'AK'
GeoState.create :country => 'US', :name => 'Arizona', :abbrev => 'AZ'
GeoState.create :country => 'US', :name => 'Arkansas', :abbrev => 'AR'
GeoState.create :country => 'US', :name => 'California', :abbrev => 'CA'
GeoState.create :country => 'US', :name => 'Colorado', :abbrev => 'CO'
GeoState.create :country => 'US', :name => 'Connecticut', :abbrev => 'CT'
GeoState.create :country => 'US', :name => 'Delaware', :abbrev => 'DE'
GeoState.create :country => 'US', :name => 'District of Columbia', :abbrev => 'DC'
GeoState.create :country => 'US', :name => 'Florida', :abbrev => 'FL'
GeoState.create :country => 'US', :name => 'Georgia', :abbrev => 'GA'
GeoState.create :country => 'US', :name => 'Hawaii', :abbrev => 'HI'
GeoState.create :country => 'US', :name => 'Idaho', :abbrev => 'ID'
GeoState.create :country => 'US', :name => 'Illinois', :abbrev => 'IL'
GeoState.create :country => 'US', :name => 'Indiana', :abbrev => 'IN'
GeoState.create :country => 'US', :name => 'Iowa', :abbrev => 'IA'
GeoState.create :country => 'US', :name => 'Kansas', :abbrev => 'KS'
GeoState.create :country => 'US', :name => 'Kentucky', :abbrev => 'KY'
GeoState.create :country => 'US', :name => 'Louisiana', :abbrev => 'LA'
GeoState.create :country => 'US', :name => 'Maine', :abbrev => 'ME'
GeoState.create :country => 'US', :name => 'Maryland', :abbrev => 'MD'
GeoState.create :country => 'US', :name => 'Massachutsetts', :abbrev => 'MA'
GeoState.create :country => 'US', :name => 'Michigan', :abbrev => 'MI'
GeoState.create :country => 'US', :name => 'Minnesota', :abbrev => 'MN'
GeoState.create :country => 'US', :name => 'Mississippi', :abbrev => 'MS'
GeoState.create :country => 'US', :name => 'Missouri', :abbrev => 'MO'
GeoState.create :country => 'US', :name => 'Montana', :abbrev => 'MT'
GeoState.create :country => 'US', :name => 'Nebraska', :abbrev => 'NE'
GeoState.create :country => 'US', :name => 'Nevada', :abbrev => 'NV'
GeoState.create :country => 'US', :name => 'New Hampshire', :abbrev => 'NH'
GeoState.create :country => 'US', :name => 'New Jersey', :abbrev => 'NJ'
GeoState.create :country => 'US', :name => 'New Mexico', :abbrev => 'NM'
GeoState.create :country => 'US', :name => 'New York', :abbrev => 'NY'
GeoState.create :country => 'US', :name => 'North Carolina', :abbrev => 'NC'
GeoState.create :country => 'US', :name => 'North Dakota', :abbrev => 'ND'
GeoState.create :country => 'US', :name => 'Ohio', :abbrev => 'OH'
GeoState.create :country => 'US', :name => 'Oklahoma', :abbrev => 'OK'
GeoState.create :country => 'US', :name => 'Oregon', :abbrev => 'OR'
GeoState.create :country => 'US', :name => 'Pennsylvania', :abbrev => 'PA'
GeoState.create :country => 'US', :name => 'Rhode Island', :abbrev => 'RI'
GeoState.create :country => 'US', :name => 'South Carolina', :abbrev => 'SC'
GeoState.create :country => 'US', :name => 'South Dakota', :abbrev => 'SD'
GeoState.create :country => 'US', :name => 'Tennessee', :abbrev => 'TN'
GeoState.create :country => 'US', :name => 'Texas', :abbrev => 'TX'
GeoState.create :country => 'US', :name => 'Utah', :abbrev => 'UT'
GeoState.create :country => 'US', :name => 'Vermont', :abbrev => 'VT'
GeoState.create :country => 'US', :name => 'Virginia', :abbrev => 'VA'
GeoState.create :country => 'US', :name => 'Washington', :abbrev => 'WA'
GeoState.create :country => 'US', :name => 'West Virginia', :abbrev => 'WV'
GeoState.create :country => 'US', :name => 'Wisconsin', :abbrev => 'WI'
GeoState.create :country => 'US', :name => 'Wyoming', :abbrev => 'WY'

#Commenting out Canada until we support international payments, taxes, and currencies
#GeoState.create :country => 'CA', :name => 'Alberta', :abbrev => 'AB'
#GeoState.create :country => 'CA', :name => 'British Columbia', :abbrev => 'BC'
#GeoState.create :country => 'CA', :name => 'Manitoba', :abbrev => 'MB'
#GeoState.create :country => 'CA', :name => 'New Brunswick', :abbrev => 'NB'
#GeoState.create :country => 'CA', :name => 'Newfoundland', :abbrev => 'NL'
#GeoState.create :country => 'CA', :name => 'Northwest Territories', :abbrev => 'NT'
#GeoState.create :country => 'CA', :name => 'Nova Scotia', :abbrev => 'NS'
#GeoState.create :country => 'CA', :name => 'Ontario', :abbrev => 'ON'
#GeoState.create :country => 'CA', :name => 'Prince Edward Island', :abbrev => 'PE'
#GeoState.create :country => 'CA', :name => 'Quebec', :abbrev => 'QC'
#GeoState.create :country => 'CA', :name => 'Saskatchewan', :abbrev => 'SK'
#GeoState.create :country => 'CA', :name => 'Yukon', :abbrev => 'YT'

