# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItemQuantity', type: :request do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let(:line_item) { LineItem.create(cart_id: cart.id, product_id: product.id, quantity: 10) }

  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'is allowed to' do
      it 'change quantity of products to buy' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 20 } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(line_item.quantity).to eq(20)
      end

      it 'remove line item from cart by typing zero in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 0 } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(cart.line_items).to eq([])
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: -1 } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Please, type positive value.')
        expect(line_item.quantity).to eq(10)
      end

      it 'type string in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 'xyz' } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Please, type positive value.')
        expect(line_item.quantity).to eq(10)
      end
    end
  end

  describe 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is allowed to' do
      it 'change quantity of products to buy' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 20 } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(line_item.quantity).to eq(20)
      end

      it 'remove line item from cart by typing zero in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 0 } }
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(cart.line_items).to eq([])
      end
    end

    context 'is not allowed to' do
      it 'type negative value in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: -1 } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Please, type positive value.')
        expect(line_item.quantity).to eq(10)
      end

      it 'type string in quantity field' do
        patch "/line_items/#{line_item.id}", params: { line_item: { quantity: 'xyz' } }
        line_item.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Please, type positive value.')
        expect(line_item.quantity).to eq(10)
      end
    end
  end

  describe 'when guest visits app' do
    it 'shopping cart is not available' do
      get "/carts/#{cart.id}"
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('You are not authorized')
    end
  end
end
