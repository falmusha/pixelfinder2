require 'rails_helper'

RSpec.describe Image, type: :model do

  describe 'validations' do
    it 'should have a unique url' do
      image = create(:image)
      duplicate_image = image.dup
      duplicate_image.valid?
      expect(duplicate_image.errors[:url]).to include('has already been taken')
    end
  end

  describe 'associations' do
    it 'belongs to creator' do
      assc = described_class.reflect_on_association(:creator)
      expect(assc.macro).to eq :belongs_to
    end
  end

end
