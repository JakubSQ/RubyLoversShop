# frozen_string_literal: true

module CartServices
  class AddProduct
    def initialize(cart, product, quantity)
      @cart = cart
      @product = product
      @quantity = quantity
    end

    def call
      if product_valid? || quantity_valid?
        OpenStruct.new({ success?: true, payload: save_line_item })
      else
        OpenStruct.new({ success?: false, payload: current_item_errors })
      end
    end

    private

    def exist_item
      @exist_item = @cart.line_items.find_by(product_id: @product.id)
    end

    def current_item
      @current_item ||= @cart.line_items.where(product_id: @product.id, quantity: @quantity).first_or_initialize
    end

    def product_valid?
      current_item.valid?
    end

    def quantity_valid?
      @quantity.positive?
    end

    def current_item_errors
      current_item.errors.full_messages || exist_item.errors.full_messages
    end

    def save_line_item
      if exist_item
        exist_item.increment(:quantity, @quantity).save
      else
        current_item.save
      end
    end
  end
end
