# frozen_string_literal: true

module CheckoutServices
  class Checkout
    def initialize(cart, user)
      @cart = cart
      @user = user
    end

    def call
      if checkout
        OpenStruct.new({ success?: true, payload: @order })
      else
        OpenStruct.new({ success?: false, payload: { error: @error } })
      end
    end

    private

    def checkout
      if @cart.line_items.present?
        ActiveRecord::Base.transaction do
          order_assignment
          line_item_update
        end
      else
        @error = 'Order has not been created. Cart was empty.'
        nil if @error.present?
      end
    rescue ActiveRecord::RecordInvalid => e
      @error = e.message

      nil if @error.present?
    end

    def order_assignment
      @payment = Payment.create!
      @shipment = Shipment.create!
      @order = Order.create!(user_id: @user.id, payment_id: @payment.id, shipment_id: @shipment.id)
    end

    def line_item_update
      @cart.line_items.each do |line_item|
        line_item.update!(cart_id: nil, order_id: @order.id)
      end
    end
  end
end
