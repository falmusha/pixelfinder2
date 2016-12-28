require 'rails_helper'

RSpec.describe Creator, type: :model do

  describe 'validations' do
    it 'should have a unique name' do
      creator = create(:creator)
      duplicate_creator = creator.dup
      expect(duplicate_creator).to_not be_valid
    end
  end

  describe 'associations' do
    it 'has many images' do
      assc = described_class.reflect_on_association(:images)
      expect(assc.macro).to eq :has_many
    end
  end

end
