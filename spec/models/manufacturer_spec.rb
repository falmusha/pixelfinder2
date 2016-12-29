require 'rails_helper'

RSpec.describe Manufacturer, type: :model do

  describe 'validations' do
    it 'should have a unique name' do
      manufacturer = create(:manufacturer)
      duplicate_manufacturer = manufacturer.dup
      expect(duplicate_manufacturer).to_not be_valid
    end
  end

end
