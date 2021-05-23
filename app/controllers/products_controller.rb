class ProductsController < ApplicationController
  before_action :set_product

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to root_path
    else
      render "edit"
    end
  end

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :cover_photo)
  end
end
