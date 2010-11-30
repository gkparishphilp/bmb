module AdminHelper

	def draw_admin_header( type )
			type = type.to_s
			str = "<div class='admin_title'><h3>Admin #{type.pluralize.capitalize} </h3></div>"
			
			new_path = eval "new_author_#{type.singularize}_path( @current_author )"
			new_name = "New #{type.singularize.capitalize}"
			
			str += "<div class='new_button'>#{link_to image_tag( 'add.png', :width => 16 ), new_path}"
			str += "  <b>#{link_to new_name, new_path}</b></div><div class='clear'>&nbsp;</div>"
			
			return str.html_safe
	end

	def draw_admin_table( collection, columns=[], opts={} )
		str = "<table class='admin_table'>"
		if collection.empty?
			str += "<tr><td><h4>None Yet</h4></td></tr></table>"
		else
			type = collection.first.class.name.singularize.downcase
			
			for column in columns do
				str += "<th>#{column.to_s}</th>"
			end
			for item in collection do
				str += "<tr>"
				for column in columns do
					if column.to_s =~ /_at\z/
						str += "<td>#{format_date_only item.send( column.to_s )}</td>"
					else
						str += "<td>#{item.send( column.to_s )}</td>"
					end
				end
				edit_path = eval "edit_author_#{type}_path( @current_author, item )"
				str += "<td>#{link_to image_tag( 'edit.png', :width => 20 ), edit_path} #{link_to 'edit', edit_path}</td>"
				str += "</tr>"
			end
			str += "</table>"
		end
		return str.html_safe
	end
	
end