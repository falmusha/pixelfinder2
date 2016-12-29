require 'rails_helper'

RSpec.describe SensorType, type: :model do

  describe 'validations' do
    it 'should have a unique name' do
      sensor_type = create(:sensor_type)
      duplicate_sensor_type = sensor_type.dup
      expect(duplicate_sensor_type).to_not be_valid
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
