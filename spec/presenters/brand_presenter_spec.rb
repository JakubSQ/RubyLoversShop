# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BrandPresenter do
  let!(:brand) { create(:brand) }
  let!(:brand1) { create(:brand) }
  let(:brand_presenter) { described_class }

  context 'Brand presenter' do
    it "displays list of brand's name" do
      expect(brand_presenter.list).to eq([brand.title, brand1.title])
    end
  end
end
