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
      @errors = errors(params[:billing_address], :build_billing_address)
      return @errors if boolean(params[:billing_address][:ship_to_bill]) == true

      @errors += errors(params[:shipping_address], :build_shipping_address)
    end

    def errors(params, method_name)
      order = Order.new
      arg_address = order.send(method_name, params)
      arg_address.valid?
      arg_address.errors.full_messages
    end
  end
end
