class Themeing < ActiveRecord::Base
	belongs_to	:author
	belongs_to	:theme
end