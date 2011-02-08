class AddIndexToCrashes < ActiveRecord::Migration
  def self.up
		add_index :crashes, :site_id
	
  end

  def self.down
  end
end
