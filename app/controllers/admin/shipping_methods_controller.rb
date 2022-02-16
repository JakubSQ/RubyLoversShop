# frozen_string_literal: true

class Admin::ShippingMethodsController < Admin::BaseController
  def index
    @shipping_methods = ShippingMethod.all
  end

  def new
    @shipping_method = ShippingMethod.new
  end

  def create
    @shipping_method = ShippingMethod.new(shipping_method_params)
    if @shipping_method.save
      redirect_to admin_shipping_methods_path, notice: 'Shipment method created successfully'
    else
      redirect_to new_admin_shipping_method_path, alert: @shipping_method.errors.full_messages.to_sentence
    end
  end

  def edit
    @shipping_method = ShippingMethod.find(params[:id])
  end

  def update
    @shipping_method = ShippingMethod.find(params[:id])
    if @shipping_method.update(shipping_method_params)
      redirect_to admin_shipping_methods_path, notice: 'Shipment method updated successfully'
    else
      redirect_to edit_admin_shipping_method_path, alert: @shipping_method.errors.full_messages.to_sentence
    end
  end

  def destroy
    @shipping_method = ShippingMethod.find(params[:id])
    @shipping_method.destroy
    redirect_to admin_shipping_methods_path, alert: 'Shipment method destroyed successfully'
  end

  private

  def shipping_method_params
    params.require(:shipping_method).permit(:name, :price, :delivery_time, :active)
  end
end
