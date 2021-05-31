# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    name { 'Coat' }
    description { 'cotton coat' }
    cover_photo { Rack::Test::UploadedFile.new(Pathname.new(Rails.root.join('spec/fixtures/coat.jpg'))) }
  end
end
