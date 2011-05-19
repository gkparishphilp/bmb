class AddNavBgToTheme < ActiveRecord::Migration
  def self.up
	add_column :themes, :nav_bg, :string
	add_column :themes, :nav_bg_selected, :string
	add_column :themes, :page_border_color, :string
  end

  def self.down
	remove_column :themes, :nav_bg
	remove_column :themes, :nav_bg_selected
	remove_column :themes, :page_border_color
  end
end
