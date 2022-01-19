# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  let(:cart) { create(:cart) }
  let(:address) { create(:address) }
  let(:user) { create(:user) }
  let(:product) { create(:product) }
  let!(:line_item) { create(:line_item, cart_id: cart.id) }

  describe 'When logged in as user' do
    context 'user types two addresses' do
      let(:address1) { create(:address) }

      it 'and order is successfully created' do
        params = { billing_address: address.as_json.symbolize_keys, shipping_address: address1.as_json.symbolize_keys,
                   user_address: '', save_address: 'value ' }
        a = Checkout::Creator.new.call(cart, user, params)

        expect(a.payload.state).to eq('new')
        expect(a.payload.user_id).to eq(user.id)
        expect(a.payload.billing_address_id).to be_present
        expect(a.payload.shipping_address_id).to be_present
      end
    end

    context 'user types only one address' do
      let(:address) { create(:address, ship_to_bill: '1') }

      it 'and order is successfully created' do
        params = { billing_address: address.as_json.symbolize_keys,
                   user_address: '', save_address: 'value ' }
        a = Checkout::Creator.new.call(cart, user, params)
        user.reload

        expect(a.payload.state).to eq('new')
        expect(a.payload.user_id).to eq(user.id)
        expect(a.payload.billing_address_id).to be_present
        expect(a.payload.shipping_address_id).to be_present
        expect(a.payload.shipping_address_id).to eq(a.payload.billing_address_id)
        expect(Address.last.user_id).not_to eq(user.id)
        expect(user.addresses).not_to be_present
      end
    end

    context 'user types one address and check it to save' do
      let(:address) { create(:address, ship_to_bill: '1') }

      it 'and order is successfully created' do
        params = { billing_address: address.as_json.symbolize_keys,
                   user_address: '', save_address: 'value 1' }
        a = Checkout::Creator.new.call(cart, user, params)
        user.reload

        expect(a.payload.state).to eq('new')
        expect(a.payload.user_id).to eq(user.id)
        expect(a.payload.billing_address_id).to be_present
        expect(a.payload.shipping_address_id).to be_present
        expect(a.payload.shipping_address_id).to eq(a.payload.billing_address_id)
        expect(Order.last.billing_address.user_id).to eq(user.id)
        expect(Order.last.shipping_address.user_id).to eq(user.id)
        expect(user.addresses).to be_present
      end
    end

    context 'user select address from address list' do
      let(:address) { create(:address, ship_to_bill: '1', user_id: user.id) }

      it 'and order is successfully created' do
        params = { billing_address: address.as_json.symbolize_keys,
                   user_address: address.id, save_address: 'value ' }
        a = Checkout::Creator.new.call(cart, user, params)

        expect(a.payload.state).to eq('new')
        expect(a.payload.user_id).to eq(user.id)
        expect(a.payload.billing_address_id).to be_present
        expect(a.payload.shipping_address_id).to be_present
        expect(a.payload.shipping_address_id).to eq(a.payload.billing_address_id)
        expect(Order.last.billing_address.user_id).to eq(user.id)
        expect(Order.last.shipping_address.user_id).to eq(user.id)
        expect(user.addresses).to be_present
      end
    end
  end
end
