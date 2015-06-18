class Photo < ActiveRecord::Base
  attr_accessible :link, :product_id, :description
  belongs_to :product

  mount_uploader :link, PhotoUploader
end
