# frozen_string_literal: true

FactoryBot.define do
  factory :shipping_method do
    sequence(:name) do |n|
      "name#{n}"
    end
    sequence(:price) do |n|
      "#{n}"
    end
    sequence(:delivery_time) do |n|
      "#{n}"
    end
    active { true }
  end
end
