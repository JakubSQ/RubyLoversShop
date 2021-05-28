# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_exception
  validates :title, presence: true
end
