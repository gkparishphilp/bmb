class EmailTemplate < ActiveRecord::Migration
  def self.up
	create_table :email_templates do |t|
		t.references 	:owner, :polymorphic => true
		t.string		:subject
		t.text			:content
		t.string		:description
		t.string		:template_type
	end
	add_index :email_templates, :template_type
  end

  def self.down
	remove_index :email_templates, :template_type
	drop_table :email_templates
  end
end
