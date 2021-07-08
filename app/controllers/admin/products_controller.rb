# frozen_string_literal: true

class Admin::ProductsController < Admin::BaseController
  def dashboard
    @q = Product.ransack(params[:q])
    @products = @q.result.includes(:category, :brand)
    @categories_list_presenter = CategoryPresenter.list
    @brands_list_presenter = BrandPresenter.list
  end

  def edit
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_root_path
      flash[:notice] = 'Product has been successfully created.'
    else
      flash[:alert] = 'Product has not been created.'
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_root_path
      flash[:notice] = 'Product has been successfully updated.'
    else
      flash[:alert] = 'Product has not been updated.'
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_root_path
    flash[:alert] = 'Product has been successfully deleted.'
  end

  private

  def product_params
    params.require(:product).permit(:name, :prize, :description, :cover_photo, :category_id, :brand_id,
                                    brand_attributes: [], category_attributes: [])
  end
end
