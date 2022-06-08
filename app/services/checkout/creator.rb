# frozen_string_literal: true

module Checkout
  class Creator
    include BooleanValue

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
      return @error = 'Invalid address' if address_form_valid?(params)

      billing_address = create_billing_address(user, params)
      shipping_address = if false?(params[:billing_address][:ship_to_bill])
                           create_shipping_address(params)
                         else
                           billing_address
                         end
      @order = Order.create!(user_id: order_user_id(user, params),
                             email: user_email(user, params),
                             payment_id: payment.id,
                             shipment_id: shipment(params).id,
                             billing_address_id: billing_address.id,
                             shipping_address_id: shipping_address.id)
    end

    def order_user_id(user, _params)
      return nil unless user

      user.id
    end

    def user_email(user, params)
      return params[:user_email] unless user

      user.email
    end

    def shipment(params)
      shipping_method = ShippingMethod.find(params[:ship_method][:shipment_id])
      Shipment.create!(shipping_method_id: shipping_method.id)
    end

    def payment
      Payment.create!
    end

    def address_form_valid?(params)
      false?(params[:billing_address][:ship_to_bill]) && params[:shipping_address].nil?
    end

    def create_billing_address(user, params)
      bill_address_param = params[:billing_address]
      Address.where(name: bill_address_param[:name],
                    street_name1: bill_address_param[:street_name1],
                    street_name2: bill_address_param[:street_name2],
                    city: bill_address_param[:city],
                    country: bill_address_param[:country],
                    state: bill_address_param[:state],
                    zip: bill_address_param[:zip],
                    phone: bill_address_param[:phone],
                    user_id: user_id(user, params)).first_or_create!
    end

    def user_id(user, params)
      user.id if save_address?(user, params) || address_exist?(user, params)
    end

    def save_address?(user, params)
      save_address = params[:save_address]
      return false if false?(save_address) || address_exist?(user, params)

      true
    end

    def address_exist?(user, params)
      return nil unless user

      user.addresses.map(&:name).include?(params[:billing_address][:name])
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
