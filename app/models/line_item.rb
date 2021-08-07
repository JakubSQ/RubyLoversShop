# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :order, optional: true

  delegate :id, :name, :prize, :category, to: :product, prefix: 'product', allow_nil: true

  def total_price
    product.prize * quantity
  end
end
