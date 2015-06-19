module ComponentsHelper

def show_binded_products
	cLinks = @component.component_links  
	if cLinks != []
		head = "<div class = 'list_items_header'><b>Где применяется</b></div>"
		links = ""
		cLinks.each do |l|
			links += "<tr class = 'item_row' ><td valign = 'middle' align = 'left' height = '40px' width = '40px'> #{image_tag(l.product.photo.link.mini) if l.product.photo != nil}</td><td valign = 'middle' align = 'left'>#{link_to(l.product.s_name, l.product, :target => "_blank", :class => 'item_links', :title => "Перейти к #{l.product.name}")}</td></tr>"
		end
		return ("#{head}<div class = 'item_field'><div class = 'table_parent'><table style = 'width: 100%;'>#{links}</table></div></div>").html_safe
	else
		return ""
	end
end

def product_show_components_table
	v = ''
	@component_types.each do |t|
		components = Component.where(:component_type_id => t, :id => @product.component_links.select(:component_id))
		v += "<tr><th align = 'left' colspan = '2'><p>#{t.name}</p></th><th id = 'linkRow'></th></tr>"
		components.each do |c|
			v += "<tr><td id = 'cPhoto' valign = 'middle'><a href = '#{ c.alter_photo }' data-lightbox='roadtrip' title = '#{ c.name }'>#{ image_tag c.alter_photo_mini, :height => '30px'  }</a></td><td valign = 'middle' align = 'left'><p>#{c.name}</p></td><td valign = 'middle' id = 'linkRow'>#{link_to 'подробнее', c}</td></tr>"
		end
	end
	return ("<table id = 'cTable'>#{v}</table>").html_safe
end

end
