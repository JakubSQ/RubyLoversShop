# frozen_string_literal: true

module LineItemUpdater
  class UpdateLineItem
    def call(quantity, line_item)
      if update_line_item(quantity, line_item)
        OpenStruct.new({ success?: true, payload: 'Your shopping cart is empty' })
      else
        OpenStruct.new({ success?: false, payload: line_item.update })
      end
    end

    private

    def update_line_item(quantity, line_item)
      if quantity <= 0
        line_item.destroy
      else
        line_item.update(quantity: quantity)
      end
    end
  end
end
