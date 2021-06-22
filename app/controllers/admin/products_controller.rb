# frozen_string_literal: true

class Admin::ProductsController < Admin::BaseController
  def dashboard
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories = Category.all
    @brands = Brand.all
    @categories_list_presenter = CategoriesPresenter.list(@categories)
    @brands_list_presenter = BrandsPresenter.list(@brands)
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :cover_photo, :category_id, :brand_id)
  end
end
