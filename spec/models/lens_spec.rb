require 'rails_helper'

RSpec.describe Lens, type: :model do
  describe 'validations' do
    it 'does not allow duplicate models per manufacturer' do
      nikon = create(:manufacturer, name: 'Nikon')
      create(:lens, manufacturer: nikon, model: 'D810')
      lens = build(:lens, manufacturer: nikon, model: 'D810')
      lens.valid?
      expect(lens.errors[:model]).to include('has already been taken')
    end
    it 'allows two manufacturers to share the same model' do
      nikon = create(:manufacturer, name: 'Nikon')
      canon = create(:manufacturer, name: 'Canon')
      create(:lens, manufacturer: nikon, model: 'D810')
      lens = build(:lens, manufacturer: canon, model: 'D810')
      expect(lens).to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to manufacturer' do
      assc = described_class.reflect_on_association(:manufacturer)
      expect(assc.macro).to eq :belongs_to
    end
    it 'belongs to sensor_type' do
      assc = described_class.reflect_on_association(:sensor_type)
      expect(assc.macro).to eq :belongs_to
    end
    it 'has many images' do
      assc = described_class.reflect_on_association(:images)
      expect(assc.macro).to eq :has_many
    end
  end

end
