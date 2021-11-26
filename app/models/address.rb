# frozen_string_literal: true

class Address < ApplicationRecord
  has_many  :billing_address, inverse_of: :address, class_name: 'Order', foreign_key: 'billing_address_id',
                              dependent: :nullify

  validates :name, :street_name1, :city, :country, :state, :zip, :phone, presence: true
  validates :zip, format: { with: /\A\d{2}-\d{3}\z/, message: 'only allows this format 12-123' }
  validates :phone, format: { with: /\A\d{9}\z/, message: 'only allows 9 digits format' }
end
