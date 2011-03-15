class DbMigrationForEcom < ActiveRecord::Migration
  def self.up
	execute 'update articles set comments_allowed = 1'
	execute 'alter table articles alter comments_allowed set default 1'
  end

  def self.down
  end
end
