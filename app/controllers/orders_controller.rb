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
    @address_presenter = AddressPresenter.new(params)
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
    billing_address_errors
    if order_params[:billing_address][:ship_to_bill] == '0'
      shipping_address_errors
      billing_address_errors + shipping_address_errors
    else
      billing_address_errors
    end
  end

  def billing_address_errors
    order = Order.new
    billing_address = order.build_billing_address(order_params[:billing_address])
    billing_address.valid?
    billing_address.errors.full_messages
  end

  def shipping_address_errors
    order = Order.new
    shipping_address = order.build_shipping_address(order_params[:shipping_address])
    shipping_address.valid?
    shipping_address.errors.full_messages
  end
end
