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

end
