# frozen_string_literal: true

class ProductsController < ApplicationController
  def index
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category)
    @categories = Category.all
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :cover_photo, :category_id)
  end
end
