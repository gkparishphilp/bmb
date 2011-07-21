class TrialSubscription < ActiveRecord::Migration
  def self.up
	add_column :subscriptions, :trial_length_in_days, :integer, :default => 30
	add_column :subscribings, :trial_end_date, :datetime
  end

  def self.down
	remove_column :subscriptions, :trial_length_in_days
	remove_column :subscribings, :trial_end_date
  end
end
