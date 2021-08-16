# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_one :payment
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  enum state: { new: 0, failed: 1, completed: 2 }, _prefix: true

  delegate :id, :email, to: :user, prefix: 'user', allow_nil: true

  def total_price
    @total_price ||= line_items.includes(:product).reduce(0) do |sum, item|
      sum + (item.quantity * item.product.prize)
    end
  end
end
