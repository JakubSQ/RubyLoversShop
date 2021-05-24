# frozen_string_literal: true

class PagesController < ApplicationController

  def home
    @products = Product.all
    @categories = Category.all
  end

end
