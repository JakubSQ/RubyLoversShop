# frozen_string_literal: true

FactoryBot.define do
  factory :line_item do
    sequence(:id) do |n|
      n
    end
    quantity { 10 }
    cart
    product
    order
  end
end
