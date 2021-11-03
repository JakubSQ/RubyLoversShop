# frozen_string_literal: true

module CheckoutServices
  class Checkout
    def call(cart, user)
      if checkout(cart, user)
        OpenStruct.new({ success?: true, payload: @order })
      else
        OpenStruct.new({ success?: false, payload: { error: @error } })
      end
    end

    private

    def checkout(cart, user)
      if cart.line_items.present?
        ActiveRecord::Base.transaction do
          @payment = Payment.create!
          @shipment = Shipment.create!
          @order = Order.create!(user_id: user.id, payment_id: @payment.id, shipment_id: @shipment.id)
          cart.line_items.each do |line_item|
            line_item.update!(cart_id: nil, order_id: @order.id)
          end
        end
      else
        @error = 'Order has not been created. Cart was empty.'
        nil if @error.present?
      end
    rescue ActiveRecord::RecordInvalid => e
      @error = e.message

      nil if @error.present?
    end
  end
end
