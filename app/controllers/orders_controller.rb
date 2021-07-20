# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_cart, only: [:new, :create, :index]
  before_action :set_order, only: %i[show edit update destroy index]

  def index; end

  def show; end

  def edit; end

  def new
    @cart = Cart.find(session[:cart_id])
  end

  def create
    @order = Order.new(order_params)
    @order.add_line_items_from_cart(cart)
    @order.user_id = current_user.id
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to root_path, notice: 'Order successfully created.'
    else
      redirect_to @order, notice: 'Something went wrong.'
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
