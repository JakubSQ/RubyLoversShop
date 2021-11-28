# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :checkout_admin!

  def new
    @order = Order.new
    @cart = Cart.find(session[:cart_id])
  end

  def create
    # binding.pry

    order = Checkout::Creator.new.call(cart, current_user, params[:order][:billing_address])
    if order.success?
      redirect_to root_path, notice: 'Order successfully created.'
    else
      redirect_to new_order_path, alert: order.payload[:error]
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

  def order_params
    params.require(:order).permit({ billing_address: [] })
  end
end

# params[:order][:address]
