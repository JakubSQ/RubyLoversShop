# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController

  def index
    @pagy, @orders = pagy(Order.order(created_at: :desc))
  end
end
