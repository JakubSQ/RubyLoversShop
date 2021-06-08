# frozen_string_literal: true

class PagesController < ApplicationController
  def home
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories = Category.all
    @brands = Brand.all
    @categories_list_presenter = CategoriesPresenter.list(@categories)
    @brands_list_presenter = BrandsPresenter.list(@brands)
  end
end
