# frozen_string_literal: true

class LineItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    product = Product.find(params[:product_id])
    add_product = CartServices::AddProduct.new.call(cart, product)
    if add_product.success?
      redirect_to cart, notice: 'Item added to cart'
    else
      redirect_to root_path
    end
  end

  def destroy
    @line_item = LineItem.find(params[:id])
    @cart = Cart.find(session[:cart_id])
    @line_item.destroy if @line_item.cart.id == @cart.id
    if @cart.line_items.count < 1
      @cart.destroy
      redirect_to root_path, notice: 'Your shopping cart is empty.'
    else
      redirect_to cart_path(@cart), notice: 'Line item was successfully destroyed.'
    end
  end

  private

  def cart
    cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = cart.id
    cart
  end
end
