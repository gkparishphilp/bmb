class DbMigrationForEcom < ActiveRecord::Migration
  def self.up
	execute 'update articles set comments_allowed = 1'
	execute 'alter table articles alter comments_allowed set default 1'
	a=Author.find_by_pen_name('Scott Sigler')
	a.contact_email = 'scottsigler@backmybook.com'
	a.save
  end

  def self.down
  end
end
