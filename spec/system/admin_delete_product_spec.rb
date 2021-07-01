# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe 'AdminDeletingProducts', type: :system do
  let!(:admin) { create(:admin) }
  let!(:product) { create(:product) }

  before do
    driven_by(:rack_test)
  end

  it 'allows admin to delete a product' do
    visit new_admin_session_path
    fill_in 'admin_email', with: admin.email
    fill_in 'admin_password', with: admin.password
    click_on 'Log in'
    visit admin_root_path
    click_on 'Delete'
    expect(page).to have_content('Product has been successfully deleted.')
    expect(page).to have_no_content(product.name)
  end
end
