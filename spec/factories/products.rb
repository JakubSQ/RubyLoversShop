# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'coat' }
    description { 'cotton coat' }
    sequence(:prize) do |n|
      "99#{n}"
    end
    cover_photo { Rack::Test::UploadedFile.new(Pathname.new(Rails.root.join('spec/fixtures/coat.jpg'))) }

    category
    brand
  end
end
