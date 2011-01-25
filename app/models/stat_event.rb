# == Schema Information
# Schema version: 20110104222559
#
# Table name: stat_events
#
#  id            :integer(4)      not null, primary key
#  statable_id   :integer(4)
#  statable_type :string(255)
#  name          :string(255)
#  ip            :string(255)
#  count         :integer(4)      default(0)
#  extra_data    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class StatEvent < ActiveRecord::Base

end
