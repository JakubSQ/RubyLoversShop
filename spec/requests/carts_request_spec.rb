# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  let!(:user) { create :user }
  let!(:product) { create :product }

  describe 'POST new product' do
    before do
      post user_session_path, params: { user: { email: user.email, password: user.password } }
    end

    it 'allows adding only one product on the list with the same name' do
      2.times { post "/line_items?product_id=#{product.id}" }

      expect(Product.count).to eq 1
    end

    it 'display product added to the cart' do
      post "/line_items?product_id=#{product.id}"
      get "/carts/#{Cart.last.id}"

      expect(response.body).to include product.name
    end

    it 'deletes all products from the cart' do
      post "/line_items?product_id=#{product.id}"
      delete "/carts/#{Cart.last.id}"

      expect(response.body).not_to include product.name
    end

    it 'checks out the order' do
      post "/line_items?product_id=#{product.id}"
      post '/carts'
      post '/orders'
      follow_redirect!

      expect(response.body).to include 'Order successfully created'
    end
  end
end
