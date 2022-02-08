# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
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

  def active_class(path)
    'active' if request.path == path
  end

  def skip_button?(request)
    request.include?("/carts/#{session[:cart_id]}")
  end

  def path(user)
    return Rails.application.routes.url_helpers.new_order_path if user

    Rails.application.routes.url_helpers.new_user_session_path
  end
end
