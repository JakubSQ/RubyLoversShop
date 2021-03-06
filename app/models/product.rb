# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  has_many :line_items, dependent: :nullify
  accepts_nested_attributes_for :brand
  accepts_nested_attributes_for :category
  has_one_attached :cover_photo
  validates :name, :prize, presence: true

  delegate :title, to: :category, prefix: 'category', allow_nil: true
  delegate :title, to: :brand, prefix: 'brand', allow_nil: true
end
