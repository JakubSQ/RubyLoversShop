# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # include CurrentCart
  # before_action :set_cart
  layout :layout_by_resource

  protected

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
