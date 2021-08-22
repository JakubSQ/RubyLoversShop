# frozen_string_literal: true

class Payment < ApplicationRecord
  has_one :order, dependent: :restrict_with_exception
  has_one :shipment, through: :order

  include AASM

  aasm do
    state :pending, initial: true
    state :failed, :completed

    event :paid do
      transitions from: :pending, to: :completed
    end

    event :cancel do
      transitions from: :pending, to: :failed
    end
  end
end
