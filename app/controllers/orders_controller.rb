# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :checkout_admin!

  def new
    @cart = Cart.find(session[:cart_id])
  end

  def confirm
    @order = Order.new
    @cart = Cart.find(session[:cart_id])
    if addresses_errors.any?
      redirect_to new_order_path, alert: addresses_errors
    else
      render :confirm 
    end
  end

  def remove_address
    @address = Address.where(id: params[:address_id]).first
    if @address.nil?
      flash[:alert] = 'Please, select saved address'
    else
      @address.update(user_id: nil)
      flash[:notice] = 'Address has been removed'
    end
  end

  def set_address
    @address = Address.where(id: params[:address_id]).first
    respond_to do |format|
      format.json { render json: @address }
    end
  end

  def create
    order = Checkout::Creator.new.call(cart, current_user, order_params)
    if order.success?
      redirect_to root_path, notice: 'Order successfully created.'
    else
      redirect_to new_order_path, alert: order.payload[:error]
    end
  end

  def destroy
    @order = Order.find(params[:id])
    @order.destroy if @order.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to root_path, notice: 'Order was successfully destroyed.'
  end

  private

  def cart
    cart = Cart.where(id: session[:cart_id]).first_or_create
    session[:cart_id] = cart.id
    cart
  end

  def order_params
    params.require(:order).permit(billing_address: %i[name street_name1 street_name2 city country state zip
                                                      phone ship_to_bill],
                                  shipping_address: %i[name street_name1 street_name2 city country state zip
                                                       phone]).merge(user_address: params[:user][:address_b],
                                                                           save_address: params[:save_address])
  end

  def addresses_errors
    order = Order.new
    if order_params[:billing_address][:ship_to_bill] == '0'
      address = order.build_billing_address(order_params[:billing_address])
      address.valid?
      address1 = order.build_shipping_address(order_params[:shipping_address])
      address1.valid?
      address.errors.full_messages + address1.errors.full_messages
    else
      address = order.build_billing_address(order_params[:billing_address])
      address.valid?
      address.errors.full_messages
    end
  end
end
