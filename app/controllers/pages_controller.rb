# frozen_string_literal: true

class PagesController < ApplicationController
  before_action :cart

  def home
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories = Category.all
    @categories_list_presenter = CategoryPresenter.list
    @brands_list_presenter = BrandPresenter.list
  end

  private

  def cart
    @cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = @cart.id
    @cart
  end
end
