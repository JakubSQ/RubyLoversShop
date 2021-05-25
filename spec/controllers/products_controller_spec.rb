require "rails_helper"

RSpec.describe ProductsController, :type => :controller do
  context "When renders page" do
    let!(:product_1) { create(:product) }
    let!(:product_2) { create(:product, name: "spodnie", category: category_1) }
    let!(:category_1) { create(:category, title: "men") }
    render_views

    describe "GET index" do
      it "renders only one category" do
        get :index
        expect(response.body).to include("spodnie")
        # expect(response.body).to include("cotton coat")
        # expect(response.body).to include("coat.jpg")
      end
    end
  end
end
