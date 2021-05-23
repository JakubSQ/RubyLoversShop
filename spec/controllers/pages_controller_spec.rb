require "rails_helper"

RSpec.describe PagesController, :type => :controller do
  context "When renders page" do
    before { create(:product) }
    render_views

    describe "GET home" do
      it "renders product" do
        get :home
        expect(response.body).to include("Coat")
        expect(response.body).to include("cotton coat")
        expect(response.body).to include("coat.jpg")
      end
    end
  end
end
