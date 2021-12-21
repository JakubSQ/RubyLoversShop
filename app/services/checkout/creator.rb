# frozen_string_literal: true

module Checkout
  class Creator
    def call(cart, user, params, save_address)
      if order_assignment(cart, user, params, save_address)
        OpenStruct.new({ success?: true, payload: @order })
      else
        OpenStruct.new({ success?: false, payload: { error: @error } })
      end
    end

    private

    def order_assignment(cart, user, params, save_address)
      if cart.line_items.present?
        ActiveRecord::Base.transaction do
          create_order(user, params, save_address)
          update_line_item(cart)
        end
      else
        @error = 'Order has not been created. Cart was empty.'
        nil if @error.present?
      end
    rescue ActiveRecord::RecordInvalid => e
      @error = e.message

      nil if @error.present?
    end

    def create_order(user, params, save_address)
      return @error = 'Invalid address' if address_form_valid?(params)

      billing_address = create_billing_address(user, params, save_address)
      shipping_address = if params[:billing_address][:ship_to_bill] == '0'
                           create_shipping_address(params)
                         else
                           billing_address
                         end
      payment ||= Payment.create!
      shipment ||= Shipment.create!
      @order = Order.create!(user_id: user.id,
                             payment_id: payment.id,
                             shipment_id: shipment.id,
                             billing_address_id: billing_address.id,
                             shipping_address_id: shipping_address.id)
    end

    def address_form_valid?(params)
      params[:billing_address][:ship_to_bill] == '0' && params[:shipping_address].nil?
    end

    def create_billing_address(user, params, save_address)
      Address.create!(name: params[:billing_address][:name],
                      street_name1: params[:billing_address][:street_name1],
                      street_name2: params[:billing_address][:street_name2],
                      city: params[:billing_address][:city],
                      country: params[:billing_address][:country],
                      state: params[:billing_address][:state],
                      zip: params[:billing_address][:zip],
                      phone: params[:billing_address][:phone],
                      user_id: (user.id if save_address == '1'))
    end

    def create_shipping_address(params)
      Address.create!(name: params[:shipping_address][:name],
                      street_name1: params[:shipping_address][:street_name1],
                      street_name2: params[:shipping_address][:street_name2],
                      city: params[:shipping_address][:city],
                      country: params[:shipping_address][:country],
                      state: params[:shipping_address][:state],
                      zip: params[:shipping_address][:zip],
                      phone: params[:shipping_address][:phone])
    end

    def update_line_item(cart)
      return @error = 'Invalid address' if @order.nil?

      cart.line_items.each do |line_item|
        line_item.update!(cart_id: nil, order_id: @order.id)
      end
    end
  end
end
