class AddSpamFilter < ActiveRecord::Migration
  def self.up
	create_table :spam_filters do |t|
		t.string :filter_type   # can be ip, user, keyword, language, domain
		t.string :filter_value  # ip address, user name
		t.string :filter_action # returns a stauts of one of these values: spam, review, publish, unpublish
	end
		
  end

  def self.down
	drop_table :spam_filters
  end
end
