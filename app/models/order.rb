# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :products, through: :line_items
  enum state: { new: 0, failed: 1, completed: 2 }, _prefix: true
end
