# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :destroy_cart, only: :destroy

  def destroy_cart
    cart = Cart.find(session[:cart_id])
    cart.destroy
  end
end
