# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many :line_items, dependent: :restrict_with_exception
  accepts_nested_attributes_for :brand
  accepts_nested_attributes_for :category
  has_one_attached :cover_photo
  validates :name, :prize, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  delegate :title, to: :category, prefix: 'category', allow_nil: true
  delegate :title, to: :brand, prefix: 'brand', allow_nil: true
end
