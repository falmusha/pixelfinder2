require 'rails_helper'

RSpec.describe Image, type: :model do

  describe 'validations' do
    it 'should have a unique page_url' do
      image = create(:image)
      dup_image = image.dup
      dup_image.valid?
      expect(dup_image.errors[:page_url]).to include('has already been taken')
    end
    it 'should have a unique image_url' do
      image = create(:image)
      dup_image = image.dup
      dup_image.valid?
      expect(dup_image.errors[:image_url]).to include('has already been taken')
    end
    it 'should have a unique thumbnail_url' do
      image = create(:image)
      dup_image = image.dup
      expect(dup_image).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to creator' do
      assc = described_class.reflect_on_association(:creator)
      expect(assc.macro).to eq :belongs_to
    end
    it 'belongs to camera' do
      assc = described_class.reflect_on_association(:camera)
      expect(assc.macro).to eq :belongs_to
    end
    it 'belongs to lens' do
      assc = described_class.reflect_on_association(:lens)
      expect(assc.macro).to eq :belongs_to
    end
  end

end
