# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  before_action :set_cart, only: %i[show destroy]

  def index
    @line_items = LineItem.all
  end

  # GET /carts/1
  def show; end

  # GET /carts/new
  def news
    @cart = Cart.new
  end

  # POST /carts
  def create
    @cart = Cart.new(cart_params)
    if @cart.save
      redirect_to @cart, notice: 'Cart was successfully created.'
    else
      render :new
    end
  end

  # DELETE /carts/1
  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to root_path, notice: 'Cart was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_cart
    @cart = Cart.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cart_params
    params.fetch(:cart, {})
  end

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to root_path, notice: "That cart doesn't exist"
  end
end
