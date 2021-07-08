# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { create(:product) }

  it 'name should be present' do
    product.name = nil
    expect(product).not_to be_valid
  end

  it 'prize should be present' do
    product.prize = nil
    expect(product).not_to be_valid
  end
end
