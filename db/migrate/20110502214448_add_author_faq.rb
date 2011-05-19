class AddAuthorFaq < ActiveRecord::Migration
  def self.up
	add_column :authors, :faq, :text
  end

  def self.down
	remove_column :authors, :faq
  end
end
