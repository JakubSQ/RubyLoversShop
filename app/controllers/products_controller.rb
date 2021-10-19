# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :cart

  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories = Category.all
    @categories_list_presenter = CategoryPresenter.list
    @brands_list_presenter = BrandPresenter.list
  end

  def show
    @product = Product.find(params[:id])
  end

  # def update
  #   @product = Product.find(params[:id])
  #   if @product.update(product_params)
  #     redirect_to products_path(@product), notice: 'updated'
  #   else
  #     redirect_to root_path, notice: 'dupa'
  #   end
  # end

  private

  def cart
    if user_signed_in?
      @cart = Cart.where(id: session[:cart_id]).first_or_create
      session[:cart_id] = @cart.id
      @cart
    end
  end

  def product_params
    params.require(:product).permit(:quantity)
  end
end
