# frozen_string_literal: true

class Address < ApplicationRecord
  has_many  :billing_address, class_name: 'Order', foreign_key: 'billing_address_id',
                              dependent: :nullify
  has_many  :shipping_address, class_name: 'Order', foreign_key: 'billing_address_id',
                              dependent: :nullify

  validates :name, :street_name1, :city, :country, :state, :zip, :phone, presence: true
  validates :zip, format: { with: /\A\d{2}-\d{3}\z/, message: 'only allows this format 12-123' }
  validates :phone,
            format: { with: /\+\(?([0-9]{2})\)?([ .-]?)([0-9]{4})\2([0-9]{5})/,
                      message: 'only allows 11 digits format with country direction' }
end
