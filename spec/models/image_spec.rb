require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'has a valid factory' do
    image = build(:image)
    expect(image).to be_valid
  end

  it 'should have a unique url' do
    image = create(:image)
    duplicate_image = image.dup
    duplicate_image.valid?
    expect(duplicate_image.errors[:url]).to include('has already been taken')
    # expect(duplicate_image).to_not be_valid
  end
end
