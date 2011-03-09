class EmailTemplate < ActiveRecord::Migration
  def self.up
	create_table :email_templates do |t|
		t.references 	:owner, :polymorphic => true
		t.string		:subject
		t.text			:content
		t.string		:description
	end
  end

  def self.down
  end
end
