# == Schema Information
# Schema version: 20110826004210
#
# Table name: crashes
#
#  id            :integer(4)      not null, primary key
#  site_id       :integer(4)
#  message       :string(255)
#  requested_url :string(255)
#  referrer      :string(255)
#  backtrace     :text
#  created_at    :datetime
#  updated_at    :datetime
#  user_note     :text
#

class Crash < ActiveRecord::Base

end
