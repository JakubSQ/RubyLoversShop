# frozen_string_literal: true

class Cart < ApplicationRecord
  has_many :line_items, dependent: :destroy

  def total_price
    line_items.to_a.sum(&:total_price)
  end
end
