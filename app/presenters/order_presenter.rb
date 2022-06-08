# frozen_string_literal: true

class OrderPresenter
  include BooleanValue

  def initialize(params)
    @params = params
  end

  def billing_params
    @params[:order][:billing_address]
  end

  def shipping_method
    ShippingMethod.find(@params[:shipment][:shipment_id]).shipping_method_info
  end

  def shipping_params
    ship_to_bill = @params[:order][:billing_address][:ship_to_bill]
    if true?(ship_to_bill)
      @params[:order][:billing_address]
    else
      @params[:order][:shipping_address]
    end
  end
end
