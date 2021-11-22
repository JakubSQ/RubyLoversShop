class Address < ApplicationRecord
  has_many  :billing_addresses, class_name: "Order", foreign_key: "billing_address_id"

  validates :name, :street_name_1, :city, :country, :zip, :phone, presence: true
  validates :zip, format: { with: /\A\d{2}-\d{3}\z/, message: "only allows this format 12-123" }
  validates :phone, format: { with: /\A\d{9}\z/, message: "only allows 9 digits format" }
end