# frozen_string_literal: true

class Shipment < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :delivery_time, presence: true, numericality: { only_integer: true }
  has_one :order, dependent: :nullify
  has_one :payment, through: :order

  include AASM

  aasm do
    state :pending, initial: true
    state :ready, :shipped, :failed, :completed, :canceled

    event :prepared do
      transitions from: :pending, to: :ready
    end

    event :cancel do
      transitions from: :pending, to: :canceled
    end

    event :delivered do
      transitions from: :ready, to: :shipped, guard: :paid?
    end

    event :reject do
      transitions from: :ready, to: :failed
    end
  end

  def shipment_info
    "#{name} - price: #{price} - avg. delivery time: #{delivery_time}"
  end

  def paid?
    payment.completed?
  end
end
