FactoryBot.define do
  factory :product do
    name { "Coat" }
    description { "cotton coat" }
    cover_photo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'coat.jpg')) }
  end
end
