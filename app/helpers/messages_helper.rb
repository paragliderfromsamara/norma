module MessagesHelper

#Мой адрес
	def my_address
		"НПП 'Норма' <info@visota-paraclub.ru>"
	end

#Подпись
	def signature
		'	
С Уважением, 
НПП "Норма" г.Самара'
	end

#Произвольное содержимое
	def default_content
		if @message_type == "" or @message_type == nil
			signature
		end
	end
#Список папок	
	def folders
		[
			["Входящие", 1, "input"],
			["Исходящие", 2, "output"],
			["Отправленные", 3, "sent"],
			["Бухгалтерия", 7, "buh"],
			["Архив", 4, "archive"],
			["Черновики", 5, "draft"],
			["Спам", 8, "spam"],
			["Корзина", 6, "urn"]
			
		]
	end

#Папка по умолчанию	
	def default_folder 
		default_folder = folders[0]  #["Входящие", 1, "input"]
	end
	
#Текущая папка	
	def current_folder
		folders.each do |folder|
			if params[:folder] == "" or params[:folder] == nil
				return default_folder
			else
				if (folder[1]).to_s == params[:folder]
					return folder
				end
			end
		end
	end

#Имя папки по id	
	def folder_name(id)
		folder_name = ""
		folders.each do |folder|
			folder_name = folder[0] if folder[1] == id 
		end
		return nil if folder_name == ""
		return folder_name if folder_name != ""
	end
#Список папок	
	def folder_list
		list = ""
		default_folder = folders[0]
		folders.each do |folder|
				list += "<a class = 'folder_links' href = '#{messages_path + "?folder=#{(folder[1]).to_s}"}'><li id = 'active_folder'>#{folder[0]} (#{(message_in_folder(folder[1])).to_s}) </li></a>" if folder == current_folder
				list += "<a class = 'folder_links' href = '#{messages_path + "?folder=#{(folder[1]).to_s}"}'><li>#{folder[0]} (#{(message_in_folder(folder[1])).to_s})</li></a>" if folder != current_folder
		end
		return ("<ul>#{list}</ul>").html_safe
	end

#Количество сообщений в папке
	def message_in_folder(id)
		messages = Message.find_all_by_folder_id(id)
		count = 0 if messages == []
		count =  messages.count if messages != []
		return count
	end
	
#Заголовок страницы	
	def page_title
		@title = current_folder[0]
	end	

#Кнопки управления почтой
	def top_buttons_list
		id = @message.id if @message != nil
		id = '' if @message == nil
		[
			['new', "#{link_to(('<li>Новое сообщение</li>').html_safe, new_message_path, :title => 'Новое сообщение')}"],
			['send', "<a onclick = sendMail('send_mail') title = 'Отправить' id = 'send_mail' href = '#'><li>Отправить</li></a>"],
			['send_multiple', "<a onclick = sendMail('send_multiple') title = 'Отправить' id = 'send_mails' href = '#'><li>Отправить</li></a>"],
			['mark_as_read', "<a title = 'Пометить как прочитанное' id = 'flagged' href = '#' name = 'letter_panel_button'><li>Пометить как прочитанное</li></a>"],
			['delete', "<a onclick = remove_to_folder('6') title = 'Удалить отмеченные' href = '#' name = 'letter_panel_button'><li>Удалить</li></a>"],
			['reply', "<a title = 'Ответить' id = 'reply' href = '/reply_to?id=#{id}' name = 'letter_panel_button'><li>Ответить</li></a>"],
			['reply_all', "<a title = 'Ответить всем' id = 'reply_all' href = '#' name = 'letter_panel_button'><li>Ответить всем</li></a>"],
			['redirect', "<a title = 'Переслать сообщение' id = 'redirect' href = '#' name = 'letter_panel_button'><li>Переслать</li></a>"],
			['clean_urn', "#{link_to( ('<li>Очистить корзину</li>').html_safe, "/clean_folder?folder_id=#{current_folder[1]}", {:confirm => 'Выполнить?'}, :title => 'Очистить корзину')}"],
			['clean_spam', "#{link_to( ('<li>Очистить спам</li>').html_safe, "/clean_folder?folder_id=#{current_folder[1]}", {:confirm => 'Вы действительно хотите очистить корзину. Выполнить?'}, :title => 'Очистить папку Спам')}"],
			['to_archive', "<a onclick = remove_to_folder('4') title = 'Переместить выбранные письма в архив' id = 'flagged' href = '#' name = 'letter_panel_button'><li>В архив</li></a>"],
			['to_buh', "<a onclick = remove_to_folder('7') title = 'Переместить выбранные письма в папку Бухгалтерия' id = 'flagged' href = '#' name = 'letter_panel_button'><li>В бухгалтерию</li></a>"],
			['to_spam', "<a onclick = remove_to_folder('8') title = 'Переместить выбранные письма в Спам' id = 'flagged' href = '#' name = 'letter_panel_button'><li>В спам</li></a>"],
			['return_to', "<a onclick = sendMail('return_to_folder') title = 'Вернуть в папку...' id = 'flagged' href = '#' name = 'letter_panel_button'><li>Вернуть</li></a>"],
			['return_from_urn', "<a onclick = sendMail('return_to_folder') title = 'Восстановить' id = 'flagged' href = '#' name = 'letter_panel_button'><li>Восстановить</li></a>"],
			['save_as_draft', "<a onclick = sendMail('save_as_draft') title = 'Сохранить в черновиках' id = 'save_as_draft' href = '#' name = 'letter_panel_button'><li>Сохранить в черновиках</li></a>"]
			
		]
	end

#построение меню управления
	def top_menu(list)
		buttons = ""
		list.each do |item|
			top_buttons_list.each do |button|
				buttons += button[1] if item == button[0]
			end
		end
		return ("<div id = 'top_menu'><ul>#{buttons}<ul></div>").html_safe
	end
	
	
# #Список сообщений в папке
	# def messages_list
		# content = ""
		# if @messages == []
			# content = "Папка #{current_folder[0]} пуста"
		# else
			# @messages.each do |message|
				# content += message_in_list_item(message)
			# end
		# end
		# return content.html_safe
	# end
	
	def message_in_list_item(message, i)
		if message.message_type == 'input'
			"
				<div id = '#{message.check_to_read}' class = 'message'>
					<table>
						<tr>
							<td onclick = 'selectCheckBox(this)' class = 'check_box_cell' title = 'Выбрать' align = 'center' valign = 'middle' id = '#{i.to_s}'>
								#{check_box("message", "#{i}",  {:id => "check_box_#{i.to_s}" }, "#{(message.id).to_s}", "no")}
							</td>
							<td>
								<a href = '#{message_path(message)}' id = 'link_to_message'>
									<div >
										<table>
											<tr>
												<td align = 'left' valign = 'middle' id = '#{message.id_in_person_cell}' class = 'person_cell'>
													От: #{message.message_from_to}
												</td>
												<td class = 'subject_content' align = 'left' valign = 'middle'>
													#{message.subject}
												</td>
												
											</tr>
										</table>
									</div>
								</a>
							</td>
							<td align = 'center' valign = 'middle'>
								#{icons(message)}
							</td>
							<td align = 'right' valign = 'middle' id = 'date_cell'>
								#{message.time}
							</td>
						</tr>
					</table>
				</div>
			"
		else
			"
				
				<div id = 'message_old' class = 'message'>
					<table>
						<tr>
							<td onclick = 'selectCheckBox(this)' class = 'check_box_cell' title = 'Выбрать' align = 'center' valign = 'middle' id = '#{i.to_s}'>
								#{check_box("message", "#{i}",  {:id => "check_box_#{i.to_s}" }, "#{(message.id).to_s}", "no")}
							</td>
							<td align = 'center' valign = 'middle'>
								#{icons(message)}
							</td>
							<td>
								<a id = 'link_to_message' href = '#{message_path(message)}'>
									<div >
										<table style = 'height: 95%;'>
											<tr>
												<td  align = 'left' valign = 'middle' title = '#{remove_corners(message.message_from_to)}' id = '#{message.id_in_person_cell}' class = 'person_cell'>
													#{truncate("Кому: #{message.message_from_to}", :length => 30)}
												</td>
												<td class = 'subject_content' align = 'left' valign = 'middle' title = '#{message.subject}'>
													#{truncate(message.subject_content, :length => 150)}
												</td>
												
											</tr>
										</table>
									</div>
								</a>
							</td>

							<td align = 'right' valign = 'middle' id = 'date_cell'>
								#{message.time}
							</td>
						</tr>
					</table>
				</div>
			"
		end
	end
	
	def icons(message)
		attch = ""
		type = "#{image_tag('/mailbox.files/input.png', :class => 'message_icon', :title => 'Входящее сообщение')}" if message.message_type == 'input'
		type = "#{image_tag('/mailbox.files/output.png', :class => 'message_icon', :title => 'Исходящее сообщение')}" if message.message_type == 'output'
		attch = "#{image_tag('/mailbox.files/screpka.png', :class => 'message_icon', :title => 'Сообщение с вложениями')}" if message.attachments != []
		return (type + attch).html_safe
	end
	
	def remove_corners(string)
		new_string = ''
		string.chars do |symb|

			if symb == "<" or symb == ">" or symb == "'" 
				symb = '"'
			end
			new_string += symb
		end
		return new_string
	end
	
	def mark_as_read
		if @message.message_type == 'input' and @message.read_flag == 1
			@message.update_attributes(:read_flag => 0)
		end
	end
	
	def message_block
		header = input_message_header if @message.message_type == 'input'
		header = output_message_header if @message.message_type == 'output'
		content = @message.message_choose_content
		
				
					
		attachments = "" if @message.attachments == []
		attachments = attachments_list if @message.attachments != []
		text = "#{header}<hr /> #{simple_format(content)} #{attachments}"
		return text.html_safe
	end
	
	def input_message_header 
		
					header = "
					<table>
						<tr>
							<td align = 'right'>
								От:
							</td>
							<td align = 'left'>
								#{@message.from}
							</td>
						</tr>
						<tr>
							<td align = 'right'>
								Копия:
							</td>
							<td align = 'left'>
								#{@message.copy}
							</td>
						</tr>
						<tr>
							<td align = 'right'>
								Тема:
							</td>
							<td align = 'left'>
								<b>#{@message.subject}</b>
							</td>
						</tr>
					</table>
				 "
	end

	def output_message_header 
		header = "
					<table>
						<tr>
							<td align = 'right'>
								Кому:
							</td>
							<td align = 'left'>
								#{@message.to}
							</td>
						</tr>
						<tr>
							<td align = 'right'>
								Копия:
							</td>
							<td align = 'left'>
								#{@message.copy}
							</td>
						</tr>
						<tr>
							<td align = 'right'>
								Тема:
							</td>
							<td align = 'left'>
								<b>#{@message.subject}</b>
							</td>
						</tr>
					</table>
				 "
	end
	
	def attachments_list
		list = "<hr /><b>Вложения: </b><br />"
		@message.attachments.each do |attachment|
			list += "
						#{link_to attachment.name, attachment.link} <br />
					"
		end
		return list
	end
	
	def raw
		mail = Mail.new(@message.content)
		text = ""
		text_html = ""
		text_plain = ""
		if mail.multipart?
			mail.parts.each do |part|
				if part.content_type.start_with?('multipart/')
					part.parts.each do |prt|
						part.parts.each do |prt|
							if prt.content_type.start_with?('text/html')
								text_html = prt.decoded
							elsif prt.content_type.start_with?('text/plain')
								text_plain = prt.decoded
							end
						end
					end
				elsif part.content_type.start_with?('text/html')
					text_html = part.decoded
				elsif part.content_type.start_with?('text/plain')
					text_plain = part.decoded
				end 
			end
		end
		text = text_html if text_html != ""
		text = text_plain if text_html == ""
		return text.html_safe
	end
	
	def reply_content
		if @message_to.input_content == ''
			return signature
		else
			header = "#{@message_to.sent_date.strftime("%d #{@message_to.ru_month(@message_to.sent_date.strftime("%m"), 'rod_padej')} %Y в %H:%M")} #{@message_to.from} написал(а): "
			text = ''
			body = "#{@message_to.text_plain}" #(@message_to.text_plain)
			text = "#{signature}
			
#{header}

#{body}

"
			
			return text
		end
	end
	
	# def insert_corners
		# text = @message_to.text_plain
		# i = 0
		# spaces_array = []
		# spaces_array[i] = 0
		# text_from = 0
		# begin
			# text_end = text.rindex(/\n/)
			# text_for_find = text[text_from..text_end]
			# ind = text.index(/\n/)
			
			# if ind != text_end 
				# i += 1
				# spaces_array[i] = ind
				# text_from = ind
			# end
		# end until(ind == text_end) 
		# x = 0
		# spaces_array.each do |value|
			# text.insert((value + x), "> ") 
			# x += 2
		# end
		# return text
	# end
end
