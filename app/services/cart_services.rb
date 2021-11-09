# frozen_string_literal: true

module CartServices
  class AddProduct
    def initialize(cart, product, quantity)
      @cart = cart
      @product = product
      @quantity = quantity
    end

    def call
      return OpenStruct.new({ success?: false, payload: 'Please, type positive value' }) if quantity_invalid?

      item = save_item
      if item.save
        OpenStruct.new({ success?: true, payload: item })
      else
        OpenStruct.new({ success?: false, payload: item.errors.full_messages })
      end
    end

    private

    def quantity_invalid?
      @quantity <= 0
    end

    def save_item
      if exist_item
        exist_item.increment(:quantity, @quantity)
      else
        current_item
      end
    end

    def current_item
      @current_item = @cart.line_items.build(product_id: @product.id, quantity: @quantity)
    end

    def exist_item
      @exist_item = @cart.line_items.find_by(product_id: @product.id)
    end
  end
end
