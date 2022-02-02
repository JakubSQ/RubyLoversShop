# frozen_string_literal: true

class PathPresenter
  def initialize(path, session, request, user)
    @path = path
    @session = session
    @request = request
    @user = user
  end

  def home
    'active' if @path == '/'
  end

  def cart
    'active' if @path == "/carts/#{@session[:cart_id]}"
  end

  def skip?
    @request.include?("/carts/#{@session[:cart_id]}")
  end

  def path
    return Rails.application.routes.url_helpers.new_order_path if @user

    Rails.application.routes.url_helpers.new_user_session_path
  end
end
