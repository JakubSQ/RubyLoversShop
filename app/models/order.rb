# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :payment
  belongs_to :shipment
  belongs_to :address, inverse_of: :order, optional: true, foreign_key: 'billing_addres_id'
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  enum state: { new: 0, failed: 1, completed: 2 }, _prefix: true
  include AASM

  aasm column: :state, enum: true do
    state :new, initial: true
    state :failed, :completed

    event :done do
      transitions from: :new, to: :completed, guard: :paid_and_shipped?
    end

    event :undone do
      transitions from: :new, to: :failed
    end
  end

  delegate :id, :email, to: :user, prefix: 'user', allow_nil: true
  delegate :id, :email, to: :admin, prefix: 'admin', allow_nil: true
  delegate :id, :aasm_state, to: :payment, prefix: 'payment', allow_nil: true
  delegate :id, :aasm_state, to: :shipment, prefix: 'shipment', allow_nil: true

  def total_price
    @total_price ||= line_items.includes(:product).reduce(0) do |sum, item|
      sum + (item.quantity * item.product.prize)
    end
  end

  def transitions
    aasm.permitted_transitions
  end

  def pay_transitions
    payment.aasm.permitted_transitions
  end

  def ship_transitions
    shipment.aasm.permitted_transitions
  end

  def paid_and_shipped?
    payment.completed? && shipment.shipped?
  end
end
