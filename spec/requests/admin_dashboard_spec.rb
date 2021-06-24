# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminDashboard', type: :request do
  describe 'GET products#dashboard' do
    let!(:user) { create :user }
    let!(:admin) { create :admin }
    let!(:product) { create :product }

    context 'when logged as an admin' do
      it 'gets list of products on admin path' do
        post admin_session_path, params: { admin: { email: admin.email, password: admin.password } }
        get '/admin'
        expect(response.body).to include(product.name)
      end
    end

    context 'when logged as a user' do
      it 'does not get list of products on admin path' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        get '/admin'
        expect(response).to redirect_to '/'
      end
    end

    context 'without logging in' do
      it 'does not get list of products on admin path' do
        get '/admin'
        expect(response).to redirect_to '/'
      end
    end
  end
end
