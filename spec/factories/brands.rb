# frozen_string_literal: true

FactoryBot.define do
  factory :brand do
    sequence(:title) do |n|
      "brand#{n}"
    end
  end
end
