# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_method do
    sequence(:name) do |n|
      "name#{n}"
    end
    sequence(:price, &:to_s)
    sequence(:delivery_time, &:to_s)
    active { true }
  end
end
