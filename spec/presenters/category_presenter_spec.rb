# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryPresenter do
  let!(:category) { create(:category) }
  let!(:category1) { create(:category) }
  let(:category_presenter) { described_class }

  context 'Category presenter' do
    it "displays list of categories' name" do
      expect(category_presenter.list).to eq([category.title, category1.title])
    end
  end
end
