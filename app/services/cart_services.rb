# frozen_string_literal: true

module CartServices
  class AddProduct
    def call(cart, product, quantity)
      if save_line_item(cart, product, quantity)
        current_item = cart.line_items.find_by(product_id: product.id)
        OpenStruct.new({ success?: true, payload: current_item })
      else
        OpenStruct.new({ success?: false, payload: { error: 'Something went wrong' } })
      end
    end

    private

    def save_line_item(cart, product, quantity)
      current_item = cart.line_items.find_by(product_id: product.id)
      if current_item
        current_item.increment(:quantity)
      else
        current_item = cart.line_items.build(product_id: product.id, quantity: quantity)
      end
      current_item.save
    end
  end
end
