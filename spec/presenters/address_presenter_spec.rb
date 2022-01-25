# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressPresenter do
  let(:address1) { create(:address) }
  let(:params) do
    { order: { billing_address: address.as_json.symbolize_keys,
               shipping_address: address1.as_json.symbolize_keys } }
  end
  let(:address_presenter) { described_class.new(params) }

  context 'Only one address name' do
    let(:address) { create(:address, ship_to_bill: 1) }

    it 'displays by address presenter' do
      expect(address_presenter.billing_params[:name]).to eq(address.name)
      expect(address_presenter.billing_params[:name]).to eq(address_presenter.shipping_params[:name])
    end
  end

  context 'Two different address names' do
    let(:address) { create(:address) }

    it 'displays by address presenter' do
      expect(address_presenter.billing_params[:name]).to eq(address.name)
      expect(address_presenter.shipping_params[:name]).to eq(address1.name)
      expect(address_presenter.billing_params[:name]).not_to eq(address_presenter.shipping_params[:name])
    end
  end
end
