# frozen_string_literal: true

module Checkout
  class Creator
    def call(cart, user, params)
      if order_assignment(cart, user, params)
        OpenStruct.new({ success?: true, payload: @order })
      else
        OpenStruct.new({ success?: false, payload: { error: @error } })
      end
    end

    private

    def order_assignment(cart, user, params)
      if cart.line_items.present?
        ActiveRecord::Base.transaction do
          create_order(user, params)
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

    def create_order(user, params)
      if params[:billing_address][:ship_to_bill] == '0'
        billing_address = create_billing_address(params)
        shipping_address = create_shipping_address(params)
      else
        billing_address = create_billing_address(params)
        shipping_address = billing_address
      end
      payment = create_payment
      shipment = create_shipment
      @order = Order.create!(user_id: user.id,
                            payment_id: payment.id,
                            shipment_id: shipment.id,
                            billing_address_id: billing_address.id,
                            shipping_address_id: shipping_address.id)
    end

    def create_payment
      Payment.create!
    end

    def create_shipment
      Shipment.create!
    end

    def create_billing_address(params)
      Address.create!(name: params[:billing_address][:name],
                      street_name1: params[:billing_address][:street_name1],
                      street_name2: params[:billing_address][:street_name2],
                      city: params[:billing_address][:city],
                      country: params[:billing_address][:country],
                      state: params[:billing_address][:state],
                      zip: params[:billing_address][:zip],
                      phone: params[:billing_address][:phone])
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
      cart.line_items.each do |line_item|
        line_item.update!(cart_id: nil, order_id: @order.id)
      end
    end
  end
end
