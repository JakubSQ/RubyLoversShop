# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminCRUD', type: :request do
  describe 'Admin CRUD actions' do
    let!(:admin) { create :admin }
    let!(:category) { create :category }
    let!(:brand) { create :brand }
    let!(:product) { build :product }
    let!(:existing_product) { create :product }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'POST admin_products_path' do
      it 'creates a new product' do
        post admin_products_path, params: { product: { name: product.name,
                                                       description: product.description,
                                                       prize: product.prize,
                                                       category_id: category.id,
                                                       brand_id: brand.id } }
        follow_redirect!
        expect(response.body).to include('Product has been successfully created')
      end
    end

    context 'DELETE /admin/products/:id' do
      it 'deletes a product' do
        delete "/admin/products/#{existing_product.id}"
        follow_redirect!
        expect(response.body).to include('Product has been successfully deleted')
      end
    end

    context 'GET /admin/products/:id/edit' do
      it 'displays edit form' do
        get "/admin/products/#{existing_product.id}/edit"
        expect(response.status).to eq(200)
      end
    end

    context 'PUT /admin/products/:id' do
      it 'update existing product' do
        put "/admin/products/#{existing_product.id}", params: { product: { name: 'trousers' } }
        follow_redirect!
        expect(response.body).to include('trousers')
      end
    end
  end
end
