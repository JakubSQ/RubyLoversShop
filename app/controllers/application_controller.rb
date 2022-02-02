# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :path_presenter
  include Pagy::Backend
  layout :layout_by_resource

  protected

  def checkout_admin!
    if admin_signed_in?
      flash[:alert] = 'Admin cannot checkout order'
      redirect_to root_path
    end
  end

  def layout_by_resource
    if devise_controller?
      'devise'
    elsif admin_signed_in?
      'admin'
    else
      'application'
    end
  end

  private

  def path_presenter
    @path_presenter = PathPresenter.new(request.path, session, request.referer, user_signed_in?)
  end
end
