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
      ActiveRecord::Base.transaction do
        @payment = Payment.create!
        @order = Order.create!(user_id: user.id, payment_id: @payment.id)
        cart.line_items.each do |line_item|
          line_item.update!(cart_id: nil, order_id: @order.id)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      @error = e.message

      nil if @error.present?
    end
  end
end
