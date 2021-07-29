module CheckoutServices
  class Checkout
    def call(order, cart, user)
      if checkout(order, cart, user)
        OpenStruct.new({ success?: true, payload: order })
      else
        OpenStruct.new({ success?: false, payload: { error: 'Something went wrong' } })
      end
    end

    private
    
    def checkout(order, cart, user)
      ActiveRecord::Base.transaction do
        order = Order.create!(user_id: user.id)
        cart.line_items.each do |line_item|
          line_item.update!(cart_id: nil, order_id: order.id)
        end
      end    
      order
    end
  end
end
