module ApplicationHelper

#meta тэги
def title
	return @title if @title != nil
	return 'Научно-Производственное Предприятие "Норма"' if @title == nil
end

def my_metatags #@page_description = "", @page_keywords = [] / добавить в тэг head шаблона
	val = ''
	val += "<meta name = 'description' content = '#{convert_for_tag(@meta_description)}'/> \n"  if @meta_description != '' and @meta_description != nil 
	val += "<meta name = 'keywords' content = '#{get_key_words}'/>" if @meta_keywords != [] and @meta_keywords != nil 
	return val.html_safe
end

def robot_meta_tag
	val = ''
	if @robots_meta != [] and @robots_meta != nil
		@robots_meta.each do |meta|
			val += "<META NAME = '#{meta[:name]}' CONTENT = '#{meta[:content]}' />"
		end
	end
	return val.html_safe
end

def get_key_words #извлекает слова из массива и преобразует их под формат тэга
	val = ''
	@meta_keywords.each do |i|
		val += convert_for_tag(i)
		val += ', ' if i != @meta_keywords.last
	end
	return val
end

def convert_for_tag(text)
	val = ''
	text.chars do |ch|
		val += ch if ch != '"'
		val += "'" if ch == '"'
	end
	return val
end
#metatags



def price
	AttachmentFile.find_all_by_file_type('price_list').last
end

def nav_buttons
	[
		{:name => 'Главная', :link => '/'},
		{:name => 'О нас', :link => '/about_us'},
		{:name => 'Продукция', :link => '/products'},
		{:name => 'Отзывы', :link => '/comments'},
		{:name => 'Контакты', :link => '/contacts'}
	]
end

def nav_panel
	val = ''
	nav_buttons.each do |but|
		val += "<a href = '#{but[:link]}'><li>#{but[:name]}</li></a>"
	end
	return ("<ul>#{val}</ul>").html_safe
end
	def collection_list(options, name, current_value)
		output = ""
		options_str = ""
		options_str += "<option value = '#{current_value[0]}'>#{current_value[1]}</option>" if current_value != []
		options.each do |option|
			options_str += "<option value = '#{option[0]}'>#{option[1]}</option>" if current_value[0] != option[0]
		end
		select_tg = "<select name = '#{name}'>#{options_str}</select>"
		return select_tg.html_safe
	end
end
