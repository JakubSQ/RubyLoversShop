# frozen_string_literal: true

module ApplicationHelper
  def bootstrap_flash_class(type)
    case type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    when 'notice'
      'alert-info'
    else
      flash_type.to_s
    end
  end

  def cart_count_over_one
    return total_cart_items if total_cart_items.positive?
  end

  def total_cart_items
    cart = Cart.where(id: session[:cart_id]).first
    return if cart.nil?

    total = cart.line_items.map(&:quantity).sum
    total.zero? ? nil : total
  end
end
