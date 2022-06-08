# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :checkout_admin!

  def new
    @cart = cart
  end

  def confirm
    @cart = cart
    @order_presenter = OrderPresenter.new(params)
    confirm = Checkout::Confirm.new.call(order_params)
    if confirm.success?
      render :confirm
    else
      redirect_to new_order_path, alert: confirm.payload[:error]
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

  def remove_address
    @address = Address.find(params[:address_id])
    if @address.nil?
      flash[:alert] = 'Please, select saved address'
    else
      @address.update(user_id: nil)
      flash[:notice] = 'Address has been removed'
    end
  end

  def set_address
    @address = Address.find(params[:address_id])
    respond_to do |format|
      format.json { render json: @address }
    end
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
                                                                     user_email: params[:user][:email],
                                                                     save_address: params[:save_address],
                                                                     ship_method: params[:shipment])
  end
end
