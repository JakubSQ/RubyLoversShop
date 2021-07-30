# frozen_string_literal: true

module LineItemServices
  class DeleteLineItem
    def call(cart, line_item)
      if delete_line_item(cart, line_item)
        if cart_empty?(cart)
          OpenStruct.new({ success?: true, payload: 'Your shopping cart is empty' })
        else
          OpenStruct.new({ success?: false, payload: 'Line Item successfully removed from shopping cart' })
        end
      else
        OpenStruct.new({ success?: true, payload: 'Something went wrong' })
      end
    end

    private

    def delete_line_item(cart, line_item)
      line_item.destroy if line_item.cart.id == cart.id
    end

    def cart_empty?(cart)
      cart.destroy if cart.line_items.count < 1
    end
  end
end
