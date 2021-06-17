# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  it 'name should be present' do
    product.name = nil
    expect(product).not_to be_valid
  end

  it 'description should be present' do
    product.description = nil
    expect(product).not_to be_valid
  end

  it 'photo should be present' do
    product.cover_photo = nil
    expect(product).not_to be_valid
  end
end
