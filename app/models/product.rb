# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many :line_items, dependent: :restrict_with_exception
  accepts_nested_attributes_for :brand
  accepts_nested_attributes_for :category
  has_one_attached :cover_photo
  validates :name, :prize, presence: true
end
