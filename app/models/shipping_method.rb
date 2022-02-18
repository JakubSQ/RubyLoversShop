# frozen_string_literal: true

class ShippingMethod < ApplicationRecord
  has_many :shipments, dependent: :nullify
  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :delivery_time, presence: true, numericality: { only_integer: true }

  def shipping_method_info
    "#{name} - price: #{price} - avg. delivery time: #{delivery_time}"
  end
end
