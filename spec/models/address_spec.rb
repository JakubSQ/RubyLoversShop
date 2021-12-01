# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { create(:address) }

  context 'name attribute' do
    it 'is present' do
      address.name = nil
      expect(address).not_to be_valid
    end
  end

  context 'street name 1 attribute' do
    it 'is present' do
      address.street_name1 = nil
      expect(address).not_to be_valid
    end
  end

  context 'street name 2 attribute' do
    it 'may be not present' do
      address.street_name2 = nil
      expect(address).to be_valid
    end
  end

  context 'city attribute' do
    it 'is present' do
      address.city = nil
      expect(address).not_to be_valid
    end
  end

  context 'country attribute' do
    it 'is present' do
      address.country = nil
      expect(address).not_to be_valid
    end
  end

  context 'state attribute' do
    it 'is present' do
      address.state = nil
      expect(address).not_to be_valid
    end
  end

  context 'zip attribute' do
    it 'is present' do
      address.state = nil
      expect(address).not_to be_valid
    end

    it 'is present and have correct format (two dogits - three digits)' do
      address.state = '12-123'
      expect(address).to be_valid
    end
  end

  context 'phone attribute' do
    it 'is present' do
      address.phone = nil
      expect(address).not_to be_valid
    end

    it 'has correct format (+48 and 9 digits)' do
      address.phone = '+48123456789'
      expect(address).to be_valid
    end
  end
end
