require 'rails_helper'

RSpec.describe Camera, type: :model do
  describe 'validations' do
    it 'does not allow duplicate models per manufacturer' do
      manu = create(:manufacturer)
      sensor = create(:sensor_type, name: 'FX')
      create(:camera, manufacturer: manu, sensor_type: sensor)
      camera = build(:camera, manufacturer: manu, sensor_type: sensor)
      camera.valid?
      expect(camera.errors[:model]).to include('has already been taken')
    end
    it 'allows two manufacturers to share the same model' do
      nikon = create(:manufacturer, name: 'Nikon')
      canon = create(:manufacturer, name: 'Canon')
      sensor = create(:sensor_type, name: 'FX')
      create(:camera, manufacturer: nikon, sensor_type: sensor)
      camera = build(:camera, manufacturer: canon, sensor_type: sensor)
      expect(camera).to be_valid
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
