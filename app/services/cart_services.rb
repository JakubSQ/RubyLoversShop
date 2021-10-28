# frozen_string_literal: true

module CartServices
  class AddProduct
    def call(cart, product, quantity)
      if product_not_valid?(cart, product, quantity)
        OpenStruct.new({ success?: false, payload: @error })
      else
        save_line_item(cart, product, quantity)
        current_item = cart.line_items.find_by(product_id: product.id) 
        OpenStruct.new({ success?: true, payload: current_item })
      end
    end

    private

    def product_not_valid?(cart, product, quantity)
      current_item = cart.line_items.build(product_id: product.id, quantity: quantity)
      current_item.valid?
      @error = current_item.errors.full_messages
      @error.size > 0
    end

    def save_line_item(cart, product, quantity)
      current_item = cart.line_items.find_by(product_id: product.id)
      if current_item
        current_item.increment(:quantity, quantity.to_i)
      else
        current_item = cart.line_items.build(product_id: product.id, quantity: quantity)
      end
      current_item.save
    end
  end
end
