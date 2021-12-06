# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    sequence(:name) do |n|
      "name#{n}"
    end
    sequence(:street_name1) do |n|
      "street name#{n}"
    end
    sequence(:city) do |n|
      "city#{n}"
    end
    sequence(:country) do |n|
      "country#{n}"
    end
    sequence(:state) do |n|
      "state#{n}"
    end
    zip { "12-12#{(rand * 10).to_i}" }
    phone { "+4812345678#{(rand * 10).to_i}" }
    ship_to_bill { 1 }
  end
end
