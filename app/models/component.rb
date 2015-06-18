class Component < ActiveRecord::Base
  attr_accessor :type_name, :products_list
  attr_accessible :cost, :description, :name, :photo_id, :component_type_id, :type_name, :uploaded_photos, :products_list

  
  
  belongs_to :component_type
  belongs_to :photo
  has_many :photos
  has_many :component_links
  
  after_save :make_component_links
  
  validates :name, :presence => {:message => "Поле 'Название' не должно быть пустым"},
				   :length => { :maximum => 32, :message => "Название не может быть длиннее 32-х знаков"},
				   :uniqueness => {:message => "Компонент с таким названием уже существует"}
  
  validate :component_type_validation
  
  def make_component_links
	prdcts = Product.all
	cLink = []
	if products_list != nil and products_list != [] and prdcts != []
		prdcts.each do |p|
			val = products_list[p.id.to_s.to_sym].to_i
			cLink = p.component_links.where(:component_id => self.id).first
			if val == 0
				cLink.destroy if cLink != nil
			elsif val == 1
				p.component_links.create(:component_id => self.id) if cLink == nil
			end
		end
	end
  end

  def component_type_validation
	if component_type_id == nil and type_name.strip == ''
		errors.add(:component_type, "Выберите тип компонента")
	end
  end
  
  def rur_cost
	(self.cost == 0.0)? 'Цена не указана':(cost.to_s + ' рублей')
  end
  
  def uploaded_photos=(attrs)
	attrs.each {|attr| self.photos.build(:link => attr)}
  end
end
