# frozen_string_literal: true

class Shipment < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :delivery_time, presence: true, numericality: { only_integer: true }

  def shipment_info
    "#{name} - price: #{price} - avg. delivery time: #{delivery_time}"
  end
end
