# frozen_string_literal: true

class UserAdminPresenter
  def initialize(order)
    @order = order
  end

  def current_email
    @order.user.nil? ? @order.admin.email : @order.user.email
  end

  def current_id
    @order.user.nil? ? @order.admin.id : @order.user.id
  end
end
