# frozen_string_literal: true

class Admin::OrdersController < Admin::BaseController
  def index
    @user_admin_presenter = UserAdminPresenter
    @pagy, @orders = pagy(Order.order(created_at: :desc))
  end

  def show
    @order = order
    @user_admin_presenter = UserAdminPresenter.new(@order)
  end

  def order_status
    @order = order
    @user_admin_presenter = UserAdminPresenter.new(@order)
    if @order.update(state: params[:state])
      flash[:notice] = "Status updated to #{@order.state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def payment_status
    @order = order
    @user_admin_presenter = UserAdminPresenter.new(@order)
    if @order.payment.update(aasm_state: params[:aasm_state])
      flash[:notice] = "Status updated to #{@order.payment.aasm_state}"
    else
      flash[:alert] = 'Something went wrong.'
    end
    render 'show'
  end

  def shipment_status
    @order = order
    @user_admin_presenter = UserAdminPresenter.new(@order)
    if @order.shipment.update(aasm_state: params[:aasm_state])
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
end
