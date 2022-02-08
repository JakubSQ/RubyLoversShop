# frozen_string_literal: true

class Admin::ShipmentsController < Admin::BaseController
  def index
    @shipments = Shipment.all
  end
end
