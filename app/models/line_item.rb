# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order, optional: true
  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0, message: 'Type pisitive value.'}

  delegate :id, :name, :prize, :category, to: :product, prefix: 'product', allow_nil: true

  def total_price
    product.prize * quantity
  end
end
