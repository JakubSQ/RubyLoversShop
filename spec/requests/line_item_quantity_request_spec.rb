# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProductsQuantity', type: :request do
  let(:product) { create(:product) }
 
  describe 'when logged in as admin' do
    let(:admin) { create(:admin) }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'is allowed to' do
      it "choose quantity of products to buy" do
        post line_items_path(product_id: product.id), params: { quantity: 10 }
        product.reload
        follow_redirect!
        expect(response.body).to include('Item added to cart')
        expect(response).to have_http_status(:ok)
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id]).quantity).to eq(10)
      end
    end

    context 'is not allowed to' do
      it "type negative value in quantity field" do
        post line_items_path(product_id: product.id), params: { quantity: -1 }
        product.reload
        follow_redirect!   
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Quantity must be greater than or equal to 1')
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id])).not_to be_present
      end

      it "type string in quantity field" do
        post line_items_path(product_id: product.id), params: { quantity: 'xyz' }
        product.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id])).not_to be_present
      end
    end
  end

  describe 'when logged in as user' do
    let!(:user) { create(:user) }

    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    context 'is allowed to' do
      it "choose quantity of products to buy" do
        post line_items_path(product_id: product.id), params: { quantity: 10 }        
        product.reload
        follow_redirect! 
        expect(response.body).to include('Item added to cart')
        expect(response).to have_http_status(:ok)
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id]).quantity).to eq(10)
      end
    end

    context 'is not allowed to' do
      it "type negative value in quantity field" do
        post line_items_path(product_id: product.id), params: { quantity: -1 }
        product.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(response.body).to include('Quantity must be greater than or equal to 1')
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id])).not_to be_present
      end

      it "type string in quantity field" do
        post line_items_path(product_id: product.id), params: { quantity: 'xyz' }
        product.reload
        follow_redirect!
        expect(response).to have_http_status(:ok)
        expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id])).not_to be_present
      end
    end
  end

  describe 'when guest visits app' do
    it 'is not allowed to choose quantity of products' do
      post line_items_path(product_id: product.id), params: { quantity: 10 }
      product.reload
      follow_redirect!
      expect(response).to have_http_status(:ok)
      expect(LineItem.find_by(product_id: product.id, cart_id: session[:cart_id])).not_to be_present
    end
  end
end
