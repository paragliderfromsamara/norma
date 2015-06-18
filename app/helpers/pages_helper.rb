module PagesHelper
	def products_array
		array = Array.new # [[product_name_1, link_to_1, image_link_1 ], ...]
		i = 0
		@products.each do |product|
			if product.photos != []
				i += 1
				array[i] = "[element_#{i}][dev_name]#{product.s_name}[/dev_name][link_to]#{product_path(product)}[/link_to][to_image]#{product.photo.link.thumb}[/to_image][to_mini_img]#{product.photo.link.mini}[/to_mini_img][/element_#{i}]"
			end
		end
		return "" if @products == []
		return array if @products != []
	end
end
