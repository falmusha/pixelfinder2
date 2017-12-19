def make_name(model_name, of)
  if of == :camera
    Pxfinder::Photography.camera_make(model_name)
  else
    Pxfinder::Photography.lens_make(model_name)
  end
end

def match_accuracy_of(list, remove_make: false, of:)
  total = 0
  total_accurate = 0
  list.each_pair do |make, models|
    next unless Pxfinder::Photography.known?(make)
    models.each do |model|
      total += 1
      model_name = remove_make ? model['name'].split.drop(1).join(' ') : model['name']
      extracted = make_name(model_name, of)

      total_accurate += 1 if extracted&.downcase&.strip == make.downcase.strip
    end
  end
  (total_accurate.to_f / total.to_f) * 100.0
end

RSpec.describe Pxfinder::Photography do
  let(:cameras_json_file) { File.join(__dir__, '../../data/cameras.json') }
  let(:lenses_json_file) { File.join(__dir__, '../../data/lenses.json') }

  let(:cameras) { JSON.parse(File.read(cameras_json_file)) }
  let(:lenses) { JSON.parse(File.read(lenses_json_file)) }

  describe '.lens_make' do
    it 'finds lens make name for all lenses' do
      accuracy = match_accuracy_of(lenses, of: :lens)
      expect(accuracy).to be >= 100.0
    end

    it 'finds most of the right make names for lenses' do
      accuracy = match_accuracy_of(lenses, remove_make: true, of: :lens)
      expect(accuracy).to be >= 94.0
    end
  end

  describe '.camera_make' do
    it 'finds the right make name for all cameras' do
      expect(match_accuracy_of(cameras, of: :camera)).to be >= 100.0
    end
  end

end
