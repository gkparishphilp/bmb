# == Schema Information
# Schema version: 20101110044151
#
# Table name: themes
#
#  id         :integer(4)      not null, primary key
#  author_id  :integer(4)
#  name       :string(255)
#  status     :string(255)
#  bg_color   :string(255)
#  text_color :string(255)
#  link_color :string(255)
#  color1     :string(255)
#  color2     :string(255)
#  color3     :string(255)
#  color4     :string(255)
#  bg_repeat  :string(255)
#  created_at :datetime
#  updated_at :datetime
#


class Theme < ActiveRecord::Base
		
	belongs_to	:author
	
	has_attached	:bg, :formats => ['jpg', 'gif', 'png']
	has_attached	:banner, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :standard => "980" }}


	
end
