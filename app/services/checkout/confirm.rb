# frozen_string_literal: true

module Checkout
  class Confirm
    include BooleanValue

    def call(params)
      if addresses_errors(params).any?
        OpenStruct.new({ success?: false, payload: { error: @errors } })
      else
        OpenStruct.new({ success?: true, payload: Order.new })
      end
    end

    private

    def addresses_errors(params)
      @errors = if boolean(params[:billing_address][:ship_to_bill]) == false
                  billing_address_errors(params) + shipping_address_errors(params)
                else
                  billing_address_errors(params)
                end
    end

    def billing_address_errors(params)
      order = Order.new
      billing_address = order.build_billing_address(params[:billing_address])
      billing_address.valid?
      billing_address.errors.full_messages
    end

    def shipping_address_errors(params)
      order = Order.new
      shipping_address = order.build_shipping_address(params[:shipping_address])
      shipping_address.valid?
      shipping_address.errors.full_messages
    end
  end
end
