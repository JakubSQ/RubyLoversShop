require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { Product.new(name: "Jacket", description: "leather jacket", cover_photo: "...") }

  before { subject.save }

  it "name should be present" do
    subject.name = nil
    expect(subject).to_not_be_valid
  end

  it "description should be present" do
    subject.description = nil
    expect(subject).to_not_be_valid
  end

  it "photo should be present" do
    subject.cover_photo = nil
    expect(subject).to_not_be_valid
  end

end
