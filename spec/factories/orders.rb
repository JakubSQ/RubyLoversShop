# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    sequence(:id) do |n|
      n
    end
    payment
    shipment
    user
  end
end
