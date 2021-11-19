# frozen_string_literal: true

module LineItemCreator
  class AddProduct
    def call(cart, product, quantity)
      return OpenStruct.new({ success?: false, payload: 'Please, type positive value' }) if quantity_invalid?(quantity)

      item = save_item(cart, product, quantity)
      if item.save
        OpenStruct.new({ success?: true, payload: item })
      else
        OpenStruct.new({ success?: false, payload: item.errors.full_messages })
      end
    end

    private

    def quantity_invalid?(quantity)
      quantity <= 0
    end

    def save_item(cart, product, quantity)
      if exist_item(cart, product)
        exist_item(cart, product).increment(:quantity, quantity)
      else
        current_item(cart, product, quantity)
      end
    end

    def current_item(cart, product, quantity)
      cart.line_items.build(product_id: product.id, quantity: quantity)
    end

    def exist_item(cart, product)
      cart.line_items.find_by(product_id: product.id)
    end
  end
end
