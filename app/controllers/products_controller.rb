# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories = Category.all
    @categories_list_presenter = CategoryPresenter.list
    @brands_list_presenter = BrandPresenter.list
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :cover_photo, :category_id, :brand_id)
  end
end
