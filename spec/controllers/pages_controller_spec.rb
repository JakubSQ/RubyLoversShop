require "rails_helper"

RSpec.describe PagesController, :type => :controller do
  describe "GET home" do
    let!(:product) { create(:product) }
    render_views

    it "renders product" do
      get :home
      expect(response.body).to include("Coat")
      expect(response.body).to include("cotton coat")
      expect(response.body).to include("coat.jpg")
    end
  end
end
