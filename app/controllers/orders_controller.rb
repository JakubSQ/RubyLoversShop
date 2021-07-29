# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show edit update destroy index]

  def index; end

  def show; end

  def edit; end

  def new
    @cart = Cart.find(session[:cart_id])
  end

  def create
    checkout = CheckoutServices::Checkout.new.call(cart, current_user)
    if checkout.success?
      redirect_to root_path, notice: 'Order successfully created.'
    else
      redirect_to root_path, notice: checkout.payload[:error]
    end
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy if @order.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to root_path, notice: 'Order was successfully destroyed.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.fetch(:order, {})
  end

  def cart
    cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = cart.id
    cart
  end
end
