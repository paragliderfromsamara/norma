module ProductsHelper
	

	def productCategoryButtons
		product = Product.new
		val = [{:title => 'Вся продукция', :link => products_path, :name => 'Все'}]
		product.categories.each do |cat|
			val[val.length] = {:title => cat[:m_name], :link => products_path(:c => cat[:id]), :name => cat[:tab_name]}
		end
		return val
	end

	def productCategoryMenu
		product = Product.new
		cur = (params[:c]).to_i
		li = ''
		productCategoryButtons.each do |but|
			li += link_to(("<li id = 'notSelCat'><div>#{but[:name]}</div></li>").html_safe, but[:link], :title => but[:title]) if product.categoryById(cur)[:tab_name] != but[:name]
			li += "<li id = 'selCat'><b><div>#{but[:name]}</div></b></li>" if product.categoryById(cur)[:tab_name] == but[:name]
		end
		return ("<div id = 'categoryMenu'><ul>#{li}</ul></div>").html_safe
	end
	def productBlock(product)
		"
			<div id = 'prodBlockFog' style = 'opacity: 0.0;'>
			</div>
			<div class = 'prodBlockText'>#{product.s_name}</div>
			<div id = 'prodBlockBut' align = 'center'><p>Подробнее</p></div>
		"
	end
	
	def mini_photo_block(entity, block_params)
				"<div style = 'width: #{block_params[:width].to_s}px; height: #{block_params[:height].to_s}px; margin-top: #{margin_top(block_params[:x_pos], block_params[:y_pos], block_params[:height]).to_s}px; margin-left: #{margin_left(block_params[:x_pos], block_params[:y_pos], block_params[:height]).to_s}px'>
					#{image_tag entity.link.thumb, :width => block_params[:width].to_s}
				</div>"
	end
	
  def file_type_ru(file_type)
	if file_type == "firmware"
		"Прошивка"
	elsif file_type == "document"
		"Текстовая документация"
	elsif file_type == "software"
		"Программное обеспечение для ПК"
	end
  end
  
  def attachments(file_type)
	files = AttachmentFile.find_all_by_product_id_and_file_type(@product.id, file_type)
	text = ""
	if files != []
		text += "
					<b>#{file_type_ru(file_type)}:</b><br />
				"
		files.each do |file|
			text += "#{link_to file.name, file.link} | #{link_to('Удалить', "/destroy_file/#{file.id}", :confirm => ("Вы уверены, что хотите удалить #{file.name}?"))}<br /> "
		end
		return text.html_safe
	else
		return ""
	end
  end
  
  def show_options(product)
	if product.options != []
		head = "<div class = 'list_items_header'>Дополнительные опции</div>"
		links = ""
		product.options.each do |option|
			links += "<tr class = 'item_row' ><td valign = 'middle' align = 'left' height = '40px' width = '40px'>#{image_tag(option.photo.link.mini, :valign => 'middle') if option.photo != nil}</td><td valign = 'middle' align = 'left'>#{link_to(option.s_name, option, :target => "_blank", :class => 'item_links', :title => "Перейти к #{option.name}")}</td></tr>"
		end
		return ("#{head}<div class = 'item_field'><div class = 'table_parent'><table style = 'width: 100%;'>#{links}</table></div></div>").html_safe
	else
		return ""
	end
  end
  
  def show_parent_device(product)
	if product.product_id != nil and product.product_id != ""
		head = "<table height = '40px'><tr><td height = '40px' width = '40px' valign = 'middle'><b>Данное изделие является опцией к #{link_to product.product.name, product.product, :target => "_blank"} </b>#{image_tag(product.product.photo.link.mini, :valign => 'middle') if product.product.photo != nil}</td></tr></table>"
		
		return ("<p>#{head}<br /></p>").html_safe
	else
		return ""
	end
  end
  
  def comments_list
	content = ""
	if @comments != []
		content += "<div class = 'list_items_header'>Отзывы:</div>"
		rows = ""
		@comments.each do |comment|
			rows += "<tr class = 'item_row'><td width='30px'>#{image_tag comment.link.mini, :valign => 'middle'}</td><td>#{link_to(("#{comment.from}").html_safe, comment, :class => 'item_links', :title => 'Перейти к отзыву')}</td></tr>"
		end
		content += "<div class = 'item_field'><div class = 'table_parent'><table style = 'width: 100%;'>#{rows}</table></div></div>"
	end
	return content.html_safe
  end
  
  def productBlocksArray(products)
	val = ""
	if products != nil
		x = 0
		y = 0
		products.each do |product| 
			style = "background-image: url('#{product.photo.link.thumb}');width: 32%;"
			if products.length == 1
				style += "margin-left:auto; margin-right: auto;"
			elsif products.length == 2
				style += "display: inline-block;float: left; left:14%;" if x == 0
				style += "display: inline-block;left:22%;" if x == 1
			elsif products.length > 2
				style += "display: inline-block;float: left;" if x == 0
				style += "display: inline-block;margin-left:2%;" if x == 1
				style += "display: inline-block;float: right;" if x == 2
			end
			val += "
					<a style = 'text-decoration: none; font-weight: normal;' href = '#{product_path(product) }'>
					<div class = 'prodBlock' style = #{'"' + style.html_safe + '"'}>
						#{ productBlock(product).html_safe }
					</div>
					</a>
			"
			x += 1
			if x == 3
				y += 1
				x = 0
			end
		end
	end 
	return val
  end
  
  def productsByCategories
	prd = Product.new
	categories = prd.categories
	val = ''
	categories.each do |cat|
		products = Product.find_all_by_category_id([0, nil]) if cat[:id] == 0
		products = Product.find_all_by_category_id(cat[:id]) if cat[:id] != 0
		if products != []
			val += "<div class = 'categoryBlock'>"
			val += "<div class = 'categoryHeader'><div id = 'text_wrapper'><h3 style = 'display: block; position: relative;top: 4px;'>#{cat[:m_name]}</h3></div></div>"
			val += "#{productBlocksArray(products)}<br />"
			val += "</div>"
		end
	end
	return val.html_safe
  end
end
