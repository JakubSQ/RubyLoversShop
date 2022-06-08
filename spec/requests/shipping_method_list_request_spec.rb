# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminShippingMethodList', type: :request do
  describe 'GET shipping_method#index' do
    context 'when logged in as admin' do
      let!(:shipping_method1) { create(:shipping_method) }
      let!(:shipping_method2) { create(:shipping_method) }
      let!(:admin) { create(:admin) }

      it 'gets list of shipping methods in admin panel' do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get '/admin/shipping_methods'
        expect(response.body).to include(shipping_method1.id.to_s)
        expect(response.body).to include(shipping_method2.id.to_s)
      end
    end

    context 'when logged id as user' do
      let!(:user) { create(:user) }

      it 'does not get list of shipping methods in admin panel' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get '/admin/shipping_methods'
        expect(response).to redirect_to '/'
      end
    end

    context 'without logging in' do
      it 'does not get list of shipping methods in admin panel' do
        get '/admin/shipping_methods'
        expect(response).to redirect_to '/'
      end
    end
  end
end
