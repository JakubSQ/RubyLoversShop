# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController
  def index
    @pagy, @orders = pagy(Order.order(created_at: :desc))
  end

  def show
    @order = order
  end

  def order_status
    @order = order
    if @order.update(state: params[:state])
      flash[:notice] = "Status updated to #{@order.state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def payment_status
    @order = order
    if @order.payment.update(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.payment.aasm_state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def shipment_status
    @order = order
    if @order.shipping_method.update(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.shipping_method.aasm_state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  private

  def order
    Order.find(params[:id])
  end
end
