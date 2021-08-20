# frozen_string_literal: true

FactoryBot.define do
  factory :payment do
    sequence(:id) do |n|
      n
    end
  end
end
