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
    if state_validation(@order, :state)
      @order.update(state: params[:state])
      flash[:notice] = "Status updated to #{@order.state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def payment_status
    @order = order
    if state_validation(@order.payment, :aasm_state)
      @order.payment.update(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.payment.aasm_state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def shipment_status
    @order = order
    if state_validation(@order.shipment, :aasm_state)
      @order.shipment.update(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.shipment.aasm_state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  private

  def order
    Order.find(params[:id])
  end

  def state_validation(obj, state)
    obj.aasm.states.map(&:name).include?(params[state].to_sym)
  end
end
