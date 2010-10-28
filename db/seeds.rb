#Setup Default Admin and Anonymous Users
puts "Setup Default Anonymous User"

admin_role = Role.create(:name => 'admin')

anon = User.new :user_name => 'Anonymous', :photo_url => "/images/anon_user.jpg"

anon.save( false )
puts "Anon saved"

s = Site.create :name => 'todo'

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
