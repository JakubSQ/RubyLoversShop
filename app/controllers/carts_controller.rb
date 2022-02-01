# frozen_string_literal: true

class CartsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart

  def show
    @cart = Cart.find(params[:id])
  end

  def create
    @cart = Cart.new
    if @cart.save
      redirect_to @cart, notice: 'Cart was successfully created.'
    else
      render :new
    end
  end

  def destroy
    cart = Cart.find(params[:id])
    cart.destroy if cart.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to root_path, notice: 'Cart was successfully destroyed.'
  end

  private

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to root_path, notice: "That cart doesn't exist"
  end
end
