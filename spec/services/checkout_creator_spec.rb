# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let(:address1) { create(:address) }
  let(:user) { create(:user) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }
  let(:params) do
    { billing_address: address.as_json.symbolize_keys, shipping_address: address1.as_json.symbolize_keys,
      user_address: user_address, save_address: save_address }
  end

  describe 'When logged in as user' do
    context 'user types two addresses' do
      let(:user_address) { '' }
      let(:save_address) { 'value ' }

      it 'and order is successfully created' do
        order = Checkout::Creator.new.call(cart, user, params)

        expect(order.payload.state).to eq('new')
        expect(order.payload.user_id).to eq(user.id)
        expect(order.payload.billing_address_id).to be_present
        expect(order.payload.shipping_address_id).to be_present
      end
    end

    context 'user types only one address' do
      let(:address) { create(:address, ship_to_bill: '1') }
      let(:user_address) { '' }
      let(:save_address) { 'value ' }

      it 'and order is successfully created' do
        order = Checkout::Creator.new.call(cart, user, params)
        user.reload

        expect(order.payload.state).to eq('new')
        expect(order.payload.user_id).to eq(user.id)
        expect(order.payload.billing_address_id).to be_present
        expect(order.payload.shipping_address_id).to be_present
        expect(order.payload.shipping_address_id).to eq(order.payload.billing_address_id)
        expect(Address.last.user_id).not_to eq(user.id)
        expect(user.addresses).not_to be_present
      end
    end

    context 'user types one address and check it to save' do
      let(:address) { create(:address, ship_to_bill: '1') }
      let(:user_address) { '' }
      let(:save_address) { 'value 1' }

      it 'and order is successfully created' do
        order = Checkout::Creator.new.call(cart, user, params)
        user.reload

        expect(order.payload.state).to eq('new')
        expect(order.payload.user_id).to eq(user.id)
        expect(order.payload.billing_address_id).to be_present
        expect(order.payload.shipping_address_id).to be_present
        expect(order.payload.shipping_address_id).to eq(order.payload.billing_address_id)
        expect(Order.last.billing_address.user_id).to eq(user.id)
        expect(Order.last.shipping_address.user_id).to eq(user.id)
        expect(user.addresses).to be_present
      end
    end

    context 'user select address from address list' do
      let(:address) { create(:address, ship_to_bill: '1', user_id: user.id) }
      let(:user_address) { address.id }
      let(:save_address) { 'value ' }

      it 'and order is successfully created' do
        order = Checkout::Creator.new.call(cart, user, params)

        expect(order.payload.state).to eq('new')
        expect(order.payload.user_id).to eq(user.id)
        expect(order.payload.billing_address_id).to be_present
        expect(order.payload.shipping_address_id).to be_present
        expect(order.payload.shipping_address_id).to eq(order.payload.billing_address_id)
        expect(Order.last.billing_address.user_id).to eq(user.id)
        expect(Order.last.shipping_address.user_id).to eq(user.id)
        expect(user.addresses).to be_present
      end
    end
  end
end
