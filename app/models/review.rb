class Review < ActiveRecord::Base
	
	validates_uniqueness_of	:reviewable_id, :scope => [ :user_id, :reviewable_type ]
	
	belongs_to      :reviewable, :polymorphic => :true
	belongs_to      :user

end