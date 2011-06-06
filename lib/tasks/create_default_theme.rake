desc "Creates a default theme"

task :create_default_theme => :environment do
   theme = Theme.create :name => 'default'
end