# frozen_string_literal: true

module Checkout
  class CurrentUser
    def call(user, params)
      if set_user(user, params)
        OpenStruct.new({ success?: true, payload: @user })
      else
        OpenStruct.new({ success?: false, payload: { error: 'Something went wrong' } })
      end
    end

    private

    def set_user(user, params)
      @user = user
      return @user if @user.present?

      @user = User.where(email: params[:user_email], registered: false).first_or_initialize
      return @user if @user.id.present?

      @user.skip_password_validation = true
      @user.save
      @user
    end
  end
end
