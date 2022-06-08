# frozen_string_literal: true

class Shipment < ApplicationRecord
  has_one :order, dependent: :nullify
  has_one :payment, through: :order
  belongs_to :shipping_method

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

  def paid?
    payment.completed?
  end
end
