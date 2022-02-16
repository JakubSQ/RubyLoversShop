# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShippingMethod, type: :model do
  let(:shipping_method) { create(:shipping_method) }

  it 'name should be present' do
    shipping_method.name = nil
    expect(shipping_method).not_to be_valid
  end

  it 'price should be present' do
    shipping_method.price = nil
    expect(shipping_method).not_to be_valid
  end

  it 'price should be integer' do
    shipping_method.price = 'integer'
    expect(shipping_method).not_to be_valid
  end

  it 'delivery time should be present' do
    shipping_method.delivery_time = nil
    expect(shipping_method).not_to be_valid
  end

  it 'delivery time should be integer' do
    shipping_method.delivery_time = 'integer'
    expect(shipping_method).not_to be_valid
  end
end
