# frozen_string_literal: true

class Brand < ApplicationRecord
  has_many :products, dependent: :nullify
  validates :title, presence: true
end
