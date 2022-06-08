# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShippingMethodActiveList', type: :request do
  describe 'GET checkout page' do
    let!(:shipping_method1) { create(:shipping_method) }
    let!(:shipping_method2) { create(:shipping_method, active: false) }

    context 'when logged in as admin' do
      let!(:admin) { create(:admin) }

      it 'is not allowed to do get checkout page' do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get '/orders/new'
        follow_redirect!

        expect(response.body).to include('Admin cannot checkout order')
      end
    end

    context 'when logged in as user' do
      let!(:user) { create(:user) }

      it 'is allowed to see only active shipping methods' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get '/orders/new'

        expect(response.body).to include(shipping_method1.shipping_method_info)
        expect(response.body).not_to include(shipping_method2.shipping_method_info)
      end
    end

    context 'without logging in' do
      it 'is allowed to see only active shipping methods' do
        get '/orders/new'

        expect(response.body).to include(shipping_method1.shipping_method_info)
        expect(response.body).not_to include(shipping_method2.shipping_method_info)
      end
    end
  end
end
