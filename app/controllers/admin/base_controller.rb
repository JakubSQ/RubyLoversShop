# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  before_action :user_admin_authenticate

  def user_admin_authenticate
    unless admin_signed_in?
      flash[:alert] = 'You are not authorized'
      redirect_to root_path
    end
  end
end
