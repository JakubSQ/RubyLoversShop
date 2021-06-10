# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_one_attached :cover_photo
  validates :name, :description, :cover_photo, presence: true
end
