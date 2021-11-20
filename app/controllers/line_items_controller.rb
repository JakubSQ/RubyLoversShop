# frozen_string_literal: true

class LineItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    product = Product.find(params[:product_id])
    add_product = LineItems::Creator.new.call(cart, product, params[:quantity].to_i)
    if add_product.success?
      redirect_to cart, notice: 'Item added to cart'
    else
      redirect_to product_path(product), alert: add_product.payload
    end
  end

  def update
    update_line_item = LineItems::Updater.new.call(params[:line_item][:quantity].to_i,
                                                   LineItem.find(params[:id]))
    if update_line_item.success?
      redirect_to cart
    else
      redirect_to root_path
    end
  end

  def destroy
    destroy_line_item = LineItems::Remover.new.call(cart, LineItem.find(params[:id]))
    if destroy_line_item.success?
      redirect_to root_path, notice: destroy_line_item.payload
    else
      redirect_to cart_path(cart), notice: destroy_line_item.payload
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
