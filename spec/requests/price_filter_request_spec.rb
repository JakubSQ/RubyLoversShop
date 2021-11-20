# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Price Filter', type: :request do
  let!(:product) { create :product }
  let!(:product1) { create :product }
  let!(:product2) { create :product }

  describe 'Admin/User/Guest is allowed to' do
    context 'choose specific price range' do
      it 'gets all products within this range' do
        get products_path(q: { prize_lteq: product1.prize, prize_gteq: product.prize })
        expect(response.body).to include("<h5>#{product.prize}$</h5>")
        expect(response.body).to include("<h5>#{product1.prize}$</h5>")
        expect(response.body).not_to include("<h5>#{product2.prize}$</h5>")
      end
    end
  end
end
