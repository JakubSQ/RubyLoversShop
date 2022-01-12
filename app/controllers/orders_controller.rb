# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :checkout_admin!

  def new
    @order = Order.new
    @cart = Cart.find(session[:cart_id])
  end

  def remove_address
    @address = Address.where(id: params[:address_id]).first
    if @address.nil?
      flash[:alert] = "Please, select saved address"
    else
      @address.update(user_id: nil)
      flash[:notice] = "Address has been removed"
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
                                                       phone saved]).merge(user_address: params[:user][:address_b],
                                                                           save_address: params[:save_address])
  end
end
