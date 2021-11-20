# frozen_string_literal: true

module Checkout
  class Creator
    def call(cart, user)
      if order_assignment(cart, user)
        OpenStruct.new({ success?: true, payload: @order })
      else
        OpenStruct.new({ success?: false, payload: { error: @error } })
      end
    end

    private

    def order_assignment(cart, user)
      if cart.line_items.present?
        ActiveRecord::Base.transaction do
          create_order(user)
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

    def create_order(user)
      @payment = Payment.create!
      @shipment = Shipment.create!
      @order = Order.create!(user_id: user.id, payment_id: @payment.id, shipment_id: @shipment.id)
    end

    def update_line_item(cart)
      cart.line_items.each do |line_item|
        line_item.update!(cart_id: nil, order_id: @order.id)
      end
    end
  end
end
