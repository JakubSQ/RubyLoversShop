# frozen_string_literal: true

class AddressPresenter
  def initialize(params)
    @params = params
  end

  def billing_params
    @params[:order][:billing_address]
  end

  def shipping_params
    if @params[:order][:billing_address][:ship_to_bill] == '1'
      @params[:order][:billing_address]
    else
      @params[:order][:shipping_address]
    end
  end
end
