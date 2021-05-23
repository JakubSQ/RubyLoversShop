class Product < ApplicationRecord
  has_one_attached :cover_photo
  belongs_to :category
end
