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

  private

  def cart
    @cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = @cart.id
    @cart
  end
end
