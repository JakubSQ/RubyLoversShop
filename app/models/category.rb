# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  validates :title, presence: true
end
