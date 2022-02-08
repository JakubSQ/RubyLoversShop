# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  layout :layout_by_resource

  protected

  def checkout_admin!
    if admin_signed_in?
      flash[:alert] = 'Admin cannot checkout order'
      redirect_to root_path
    end
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    elsif admin_signed_in?
      'admin'
    else
      'application'
    end
  end
end
