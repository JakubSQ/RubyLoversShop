# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  accepts_nested_attributes_for :brand
  accepts_nested_attributes_for :category
  has_one_attached :cover_photo
  validates :name, :prize, presence: true
end
