# frozen_string_literal: true

class Product < ApplicationRecord
  before_destroy :not_referenced_by_any_line_item
  belongs_to :category
  belongs_to :brand
  has_many :line_items, dependent: :restrict_with_exception
  accepts_nested_attributes_for :brand
  accepts_nested_attributes_for :category
  has_one_attached :cover_photo
  validates :name, :prize, presence: true

  def not_referenced_by_any_line_item
    unless line_items.empty?
      errors.add(:base, 'Line items present')
      throw :abort
    end
  end
end
