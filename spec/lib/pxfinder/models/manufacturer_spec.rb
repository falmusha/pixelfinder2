RSpec.describe Pxfinder::Models::Manufacturer do

  let(:cameras_json_file) { File.join(__dir__, '../../../data/cameras.json') }
  let(:lenses_json_file) { File.join(__dir__, '../../../data/lenses.json') }

  let(:cameras) { JSON.parse(File.read(cameras_json_file)) }
  let(:lenses) { JSON.parse(File.read(lenses_json_file)) }

  describe '.extract_make_name' do

    context 'with make prepended in model name' do
      it 'finds the right make name for all lenses' do
        expect(match_accuracy_of(lenses)).to be >= 100.0
      end

      it 'finds the right make name for all cameras' do
        expect(match_accuracy_of(cameras)).to be >= 100.0
      end
    end

    context 'without make in model name' do
      it 'finds most of the right make names for lenses' do
        expect(match_accuracy_of(lenses, remove_make: true)).to be >= 94.0
      end
    end

  end

  def match_accuracy_of(cameras_or_lenses, remove_make: false)
    total = 0
    total_accurate = 0
    cameras_or_lenses.each_pair do |make, models|
      # skip unsupported manufacturers
      next unless Pxfinder::Models::Manufacturer.known?(make)

      models.each do |model|
        total += 1
        model_name = if remove_make
                       model["name"].split.drop(1).join(" ")
                      else
                       model["name"]
                      end
        extracted = Pxfinder::Models::Manufacturer.extract_make_name(model_name)
        if extracted && extracted.downcase.strip == make.downcase.strip
          total_accurate += 1
        else
          # puts "#{model_name} -> #{extracted}"
        end

      end
    end

    (total_accurate.to_f / total.to_f) * 100.0
  end
end

