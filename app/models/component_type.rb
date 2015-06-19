class ComponentType < ActiveRecord::Base
  attr_accessible :name
  has_many :components
  
  validates :name, :presence => {:message => "Поле 'Название типа' не должно быть пустым"},
				   :length => { :maximum => 32, :message => "Название не может быть длиннее 32-х знаков"},
				   :uniqueness => {:message => "Тип компонента с таким названием уже существует"}
end
