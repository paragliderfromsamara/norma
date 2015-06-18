class Product < ActiveRecord::Base
  attr_accessible :cost, :description, :in_warehouse, :name, :product_id, :short_name, :notice, :visibility, :uploaded_photos, :photo_id, :visible_in_slider, :order_number, :note, :category_id
  has_many :photos, :dependent => :delete_all
  has_many :attachment_files, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  belongs_to :photo
  belongs_to :product
  
  def categories
	[	
		{:id => 2, :name => 'Измерительная ситема', :m_name => 'Измерительные системы', :tab_name => 'Системы'},
		{:id => 1, :name => 'Измерительный прибор', :m_name => 'Измерительные приборы', :tab_name => 'Приборы'},	
		{:id => 3, :name => 'Измерительный комплекс', :m_name => 'Измерительные комплексы', :tab_name => 'Комплексы'},
		{:id => 4, :name => 'Высоковольтная установка', :m_name => 'Высоковольтные установки', :tab_name => 'Установки'},
		{:id => 5, :name => 'Дополнительная опция', :m_name => 'Дополнительные опции', :tab_name => 'Опции'}		
		#{:id => 100, :name => 'Остальное', :m_name => 'Остальное', :tab_name => 'Остальное'}
	]
  end
  
  def category
	val = {}
	if self.category_id == nil
		val = categories.first
	else
		categories.each do |cat|
			val = cat if cat[:id] == self.category_id  
		end
		val = categories.first if val == {}
	end
	return val
  end
  
  def categoryById(cat_id)
	val = {}
	if cat_id == nil
		val = {:tab_name => 'Все', :m_name => 'Вся производимая продукция'}
	else
		categories.each do |cat|
			val = cat if cat[:id] == cat_id 
		end
		val = {:tab_name => 'Все', :m_name => 'Вся производимая продукция'} if val== {}
	end
	return val
  end
  
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr)}
  end
  
  def visibility_statuses
	[["Показывать в каталоге продукции", "visible"], ["Не показывать в каталоге продукции", "invisible"]]
  end
  
  def visibility_status(status)
	if status == 'visible'
		"Показывать в каталоге продукции"
	elsif status == 'invisible'
		"Не показывать в каталоге продукции"
	end
  end
  
  def s_name
	if short_name != ''
		short_name
	else
		name
	end
  end
  
  def options
	Product.find_all_by_product_id(id)
  end
  
  def rur_cost
	cost.to_s + ' рублей'
  end
  
  def nds
	"<span style = 'color: #0D5244;'>*Цена указана без НДС в связи с применением упрощённой системы налогообложения</span>"
  end
  
end

