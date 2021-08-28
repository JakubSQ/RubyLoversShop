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
    if @order.update!(state: params[:state])
      flash[:notice] = "Status updated to #{@order.state}"
      render 'show'
    else
      flash[:alert] = 'Something went wrong.'
      render 'index'
    end
  end

  def payment_status
    @order = order
    if @order.payment.update!(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.payment.aasm_state}"
      render 'show'
    else
      flash[:alert] = 'Something went wrong.'
      render 'index'
    end
  end

  def shipment_status
    @order = order
    if @order.shipment.update!(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.shipment.aasm_state}"
      render 'show'
    else
      flash[:alert] = 'Something went wrong.'
      render 'index'
    end
  end

  private

  def order
    Order.find(params[:id])
  end
end
