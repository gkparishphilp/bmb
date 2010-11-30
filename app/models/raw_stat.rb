# == Schema Information
# Schema version: 20101120000321
#
# Table name: raw_stats
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


class RawStat < ActiveRecord::Base
	belongs_to	:statable, :polymorphic => true
	after_create :rate_limit

	scope :views, where( "name = 'view' " )

	scope :downloads, where(" name = 'download' ")

	def rate_limit
		now = Time.now.getutc
		Delayed::Job.enqueue(ProcessStatJob.new(now, self))
	end

end

