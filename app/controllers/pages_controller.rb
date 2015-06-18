class PagesController < ApplicationController
  def index
	@title = 'Главная'
	@header = @title
	@attachment_file = AttachmentFile.new if user_type == 'admin'
	@meta_description = "Разработка и производство высокоточных измерительных приборов, систем и установок контроля качества кабельной продукции."
	@products = Product.find_all_by_visible_in_slider('yes', :order => 'name ASC')
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
  end

  def contacts
	@title = 'Контакты и реквизиты'
	@header = @title
	@meta_description = "Контактная информация и реквизиты."
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
  end

  def about_us
	@title = 'О нас'
	@header = @title
	@meta_description = "Коротко о нашем предприятии"
	@robots_meta = [{:name => 'ROBOTS', :content => 'INDEX, FOLLOW'}]
  end

end
