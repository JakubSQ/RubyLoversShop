# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Checkout, type: :model do
  context 'When user is logged in' do
    let(:user) { create(:user) }
    let(:params) do
      { user_email: user.email }
    end

    it 'current user is set as logged in user ' do
      current_user = Checkout::CurrentUser.new.call(user, params)

      expect(current_user.payload.id).to eq(user.id)
    end
  end

  context 'Without logging in' do
    let(:user) { nil }
    let(:email) { 'example@email.com' }
    let(:params) do
      { user_email: email }
    end

    it 'current user is set as a new user' do
      current_user = Checkout::CurrentUser.new.call(user, params)

      expect(current_user.payload.email).to eq(User.last.email)
    end
  end

  context 'Without logging in and blank email address' do
    let(:user) { nil }
    let(:email) { '' }
    let(:params) do
      { user_email: email }
    end

    it 'error would be raised' do
      current_user = Checkout::CurrentUser.new.call(user, params)

      expect(current_user.payload[:error]).to eq(["Email can't be blank"])
    end
  end

  context 'Without logging in with existing record' do
    let(:user) { nil }
    let!(:user1) { create(:user, email: 'example@email.com', registered: false) }
    let(:email) { 'example@email.com' }
    let(:params) do
      { user_email: email }
    end

    it 'current user is set as a new user found in database' do
      current_user = Checkout::CurrentUser.new.call(user, params)

      expect(current_user.payload.id).to eq(user1.id)
    end
  end
end
