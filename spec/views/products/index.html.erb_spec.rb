require "rails_helper"

RSpec.describe "products?q%5Bcategory_title_eq%5D=women&q%5Bcommit%5D=Search", type: :view do
  before(:each) do
    assign(:categories, [
      Category.create!(title: "men"),
      Category.create!(title: "women"),
      Category.create!(title: "unisex")
    ])
    # binding.pry
  end

  before(:each) do
    assign(:products, [
      Product.create!(
        name: "Coat",
        description: "Black coat",
        cover_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'coat.jpg'))
      ),
      Product.create!(
        name: "Hat",
        description: "Black hat",
        cover_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'coat.jpg'))
      ),
      Product.create!(
        name: "Shirt",
        description: "Black shirt",
        cover_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'coat.jpg'))
      )
    ])
  end

  it "renders only one category" do

    render

    rendered.should_not contain("men")
    rendered.should contain("women")
    rendered.should_not contain("unisex")
  end
end
