require 'rails_helper'

RSpec.describe Manufacturer, type: :model do

  describe 'validations' do
    it 'should have a unique name' do
      manufacturer = create(:manufacturer)
      duplicate_manufacturer = manufacturer.dup
      expect(duplicate_manufacturer).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many camera' do
      assc = described_class.reflect_on_association(:cameras)
      expect(assc.macro).to eq :has_many
    end
    it 'has many lenses' do
      assc = described_class.reflect_on_association(:lenses)
      expect(assc.macro).to eq :has_many
    end
  end

end
