# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/shipping_methods', type: :request do
  describe 'Admin CRUD actions' do
    let!(:admin) { create :admin }
    let!(:shipping_method) { build :shipping_method }
    let!(:existing_shipping_method) { create :shipping_method }

    before do
      post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
    end

    context 'POST admin_shipping_method_path' do
      it 'creates a new shipping method' do
        post admin_shipping_methods_path, params: { shipping_method: { name: shipping_method.name,
                                                                       price: shipping_method.price,
                                                                       delivery_time: shipping_method.delivery_time,
                                                                       active: shipping_method.active } }
        follow_redirect!
        expect(response.body).to include('Shipping method created successfully')
      end
    end

    context 'DELETE /admin/shipping_methods/:id' do
      it 'deletes a shipping method' do
        delete "/admin/shipping_methods/#{existing_shipping_method.id}"
        follow_redirect!
        expect(response.body).to include('Shipping method destroyed successfully')
      end
    end

    context 'GET /admin/shipping_methods/:id/edit' do
      it 'displays edit form' do
        get "/admin/shipping_methods/#{existing_shipping_method.id}/edit"
        expect(response.status).to eq(200)
      end
    end

    context 'PUT /admin/shipping_methods/:id' do
      it 'update existing shipping method' do
        put "/admin/shipping_methods/#{existing_shipping_method.id}", params: { shipping_method: { name: 'ups' } }
        follow_redirect!
        expect(response.body).to include('ups')
      end
    end
  end
end
