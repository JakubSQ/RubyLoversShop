# frozen_string_literal: true

class Admin::ShipmentsController < Admin::BaseController
  def index
    @shipments = Shipment.all
  end

  def new
    @shipment = Shipment.new  
  end

  def create
    @shipment = Shipment.new(shipment_params)
    if @shipment.save
      redirect_to admin_shipments_path, notice: 'Shipment method created successfully'
    else
      redirect_to new_admin_shipment_path, alert: @shipment.errors.full_messages.to_sentence
    end
  end

  def edit
    @shipment = Shipment.find(params[:id]) 
  end

  def update
    @shipment = Shipment.find(params[:id])
    if @shipment.update(shipment_params)
      redirect_to admin_shipments_path, notice: 'Shipment method updated successfully'
    else
      redirect_to edit_admin_shipment_path, alert: @shipment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @shipment = Shipment.find(params[:id])
    @shipment.destroy
    redirect_to admin_shipments_path, alert: 'Shipment method destroyed successfully'
  end

  private

  def shipment_params
    params.require(:shipment).permit(:name, :price, :delivery_time)
  end
end
