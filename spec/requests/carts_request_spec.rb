# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let!(:user) { create :user }
  let!(:product) { create :product }
  let(:address) { create :address }

  describe 'Actions on products' do
    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'POST new product' do
      it 'allows adding only one product on the list with the same name' do
        2.times { post line_items_path(product_id: product.id), params: { quantity: 1 } }
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id]).quantity).to eq(2)
      end

      it 'displays product added to the cart' do
        post line_items_path(product_id: product.id), params: { quantity: 1 }
        get "/carts/#{Cart.last.id}"

        expect(response.body).to include product.name
      end
    end

    context 'DELETE existing products' do
      it 'deletes all products from the cart' do
        post line_items_path(product_id: product.id), params: { quantity: 1 }
        delete "/carts/#{Cart.last.id}"

        expect(response.body).not_to include product.name
      end
    end

    context 'Checking out' do
      it 'checks out the order' do
        post line_items_path(product_id: product.id), params: { quantity: 1 }
        post '/carts'
        post orders_path, params: { user: { address_b: '' },
                                    order: { billing_address: { name: address.name,
                                                                street_name1: address.street_name1,
                                                                city: address.city,
                                                                country: address.country,
                                                                state: address.state,
                                                                zip: address.zip,
                                                                phone: address.phone,
                                                                ship_to_bill: 1 } } }
        follow_redirect!
        expect(response.body).to include 'Order successfully created'
      end
    end
  end
end
