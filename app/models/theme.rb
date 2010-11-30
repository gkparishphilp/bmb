# == Schema Information
# Schema version: 20101120000321
#
# Table name: themes
#
#  id               :integer(4)      not null, primary key
#  creator_id       :integer(4)
#  name             :string(255)
#  status           :string(255)     default("active")
#  show_pen_name    :boolean(1)      default(TRUE)
#  bg_color         :string(255)
#  bg_repeat        :string(255)
#  banner_bg_color  :string(255)     default("#ffffff")
#  banner_repeat    :string(255)
#  header_color     :string(255)
#  content_bg_color :string(255)     default("#ffffff")
#  title_color      :string(255)
#  text_color       :string(255)
#  link_color       :string(255)
#  hover_color      :string(255)
#  book_site        :boolean(1)
#  public           :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#


class Theme < ActiveRecord::Base
		
	has_many	:theme_ownings
	has_many	:authors, :through => :theme_ownings
	belongs_to	:creator, :class_name => 'Author'
	
	has_attached	:bg, :formats => ['jpg', 'gif', 'png']
	has_attached	:banner, :formats => ['jpg', 'gif', 'png'], :process => { :resize => { :standard => "980" }}

	scope :public, where( "public = true" )
	scope :default, where( "creator_id is null" )

	def activate_for( author )
		unless author.theme_ownings.empty?
			owning_to_deactivate = author.theme_ownings.find_by_theme_id( author.active_theme.id ) if author.active_theme.present?
			owning_to_activate = author.theme_ownings.find_by_theme_id( self.id )
		end
		
		if owning_to_activate.nil?
			author.themes << self
			owning_to_activate = author.theme_ownings.find_by_theme_id( self.id )
		end
		owning_to_activate.activate
		return owning_to_deactivate.deactivate unless owning_to_deactivate.nil?
	end
	
end
