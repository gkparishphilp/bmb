# == Schema Information
# Schema version: 20101120000321
#
# Table name: assets
#
#  id                 :integer(4)      not null, primary key
#  book_id            :integer(4)
#  type               :string(255)
#  title              :string(255)
#  description        :text
#  download_count     :integer(4)      default(0)
#  asset_type         :string(255)
#  unlock_requirement :string(255)
#  content            :text(2147483647
#  duration           :string(255)
#  bitrate            :string(255)
#  resolution         :string(255)
#  word_count         :integer(4)
#  origin             :string(255)
#  status             :string(255)     default("publish")
#  created_at         :datetime
#  updated_at         :datetime
#

class Pdf < Asset
	has_attached :pdf, :formats => ['pdf'], :private => true
end
