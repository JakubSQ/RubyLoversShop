# frozen_string_literal: true

class OmniauthController < ApplicationController
  def facebook
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'You are logged in through Facebook'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to new_user_registration_path
    end
  end

  def github
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'You are logged in through Github'
    else
      flash[:error] = 'There was a problem signing you in through Github. Please register or try signing in later'
      redirect_to new_user_registration_path
    end
  end

  def google_oauth2
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      flash[:notice] = 'You are logged in through Google'
    else
      flash[:error] = 'There was a problem signing you in through Google. Please register or try signing in later'
      redirect_to new_user_registration_path
    end
  end

  def failure
    flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to new_user_registration_path
  end
end
