# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProductsQuantity', type: :request do
  let!(:product) { create(:product) }
  let!(:cart) { create(:cart) }

  # describe 'when logged in as admin' do
  #   let(:admin) { create(:admin) }

  #   before do
  #     post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
  #   end

  #   context 'is allowed to' do
  #     it "choose quantity of products to buy" do
  #       post line_items_path, params: { product: { product_id: product.id, cart_id: cart.id, quantity: 10 } }
  #       follow_redirect!
  #       expect(response.body).to include('Item added to cart')
  #       expect(response).to have_http_status(:ok)
  #       expect(line_item.quantity).to eq(10)
  #     end
  #   end

  #   context 'is not allowed to' do
  #     it "type string in quantity field" do
  #       post line_items_path, params: { product: { product_id: product.id, cart_id: cart.id, quantity: 'ten' } }
  #       follow_redirect!
  #       expect(response).to have_http_status(:found)
  #       expect(response).to redirect_to '/'
  #       expect(response.body).to include('Something went wrong')
  #     end

  #     it "type negative value in quantity field" do
  #       post line_items_path, params: { line_item: { product_id: product.id, cart_id: cart.id, quantity: -1 } }
  #       follow_redirect!
  #       expect(response).to have_http_status(:found)
  #       expect(response).to redirect_to '/'
  #       expect(response.body).to include('Something went wrong')
  #     end
  #   end
  # end

  describe 'when logged in as user' do
    let(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is allowed to' do
      it "choose quantity of products to buy" do
        post line_items_path, params: { line_item: { product_id: product.id, cart_id: cart.id, quantity: 10 } }
        
        binding.pry
        follow_redirect!
        
        binding.pry
        
        expect(response.body).to include('Item added to cart')
        expect(response).to have_http_status(:ok)
        expect(line_item.quantity).to eq(10)
      end
    end

    context 'is not allowed to' do
      it "type string in quantity field" do
        post line_items_path, params: { product: { product_id: product.id, cart_id: cart.id, quantity: 'ten' } }
        follow_redirect!
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
        expect(response.body).to include('Something went wrong')
      end

      it "type negative value in quantity field" do
        post line_items_path, params: { product: { product_id: product.id, cart_id: cart.id, quantity: -1 } }
        follow_redirect!
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to '/'
        expect(response.body).to include('Something went wrong')
      end
    end
  end

  describe 'when guest visits app' do
    it 'is not allowed to choose quantity of products' do
      post line_items_path, params: { product: { product_id: product.id, cart_id: cart.id, quantity: -1 } }
      follow_redirect!
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to '/'
    end
  end
end
