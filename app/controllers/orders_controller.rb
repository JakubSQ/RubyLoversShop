# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = Cart.find(session[:cart_id])
  end

  def create
    checkout = CheckoutServices::Checkout.new(cart, current_user).call
    if checkout.success?
      redirect_to root_path, notice: 'Order successfully created.'
    else
      redirect_to root_path, notice: checkout.payload[:error]
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy if @order.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to root_path, notice: 'Order was successfully destroyed.'
  end

  private

  def cart
    cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = cart.id
    cart
  end
end
