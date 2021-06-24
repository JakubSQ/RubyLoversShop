# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    sequence(:email) do |n|
      "person#{n}@example.com"
    end
    password { 'password' }
  end
end
