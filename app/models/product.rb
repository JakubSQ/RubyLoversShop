class Product < ApplicationRecord
  has_one_attached :cover_photo
  validates :name, :description, :cover_photo, presence: true
end
