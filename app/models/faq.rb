# == Schema Information
# Schema version: 20110606205010
#
# Table name: faqs
#
#  id            :integer(4)      not null, primary key
#  author_id     :integer(4)
#  title         :string(255)
#  content       :text
#  listing_order :integer(4)
#  status        :string(255)     default("publish")
#  created_at    :datetime
#  updated_at    :datetime
#

class Faq < ActiveRecord::Base
	
	belongs_to :author
	
	searchable_on	[ :title ]
end
