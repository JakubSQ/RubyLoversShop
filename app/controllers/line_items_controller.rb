# frozen_string_literal: true

class LineItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    product = Product.find(params[:product_id])
    add_product = CartServices::AddProduct.new(cart, product, params[:quantity].to_i).call
    if add_product.success?
      redirect_to cart, notice: 'Item added to cart'
    else
      redirect_to product_path(product), alert: add_product.payload
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
    if @line_item.update(line_item_params)
      @line_item.destroy if @line_item.quantity.zero?
    else
      flash[:alert] = 'Please, type positive value.'
    end
    redirect_to cart
  end

  def destroy
    delete_line_item = LineItemServices::DeleteLineItem.new.call(cart, LineItem.find(params[:id]))
    if delete_line_item.success?
      redirect_to root_path, notice: delete_line_item.payload
    else
      redirect_to cart_path(cart), notice: delete_line_item.payload
    end
  end

  private

  def cart
    cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = cart.id
    cart
  end

  def line_item_params
    params.require(:line_item).permit(:quantity)
  end
end
