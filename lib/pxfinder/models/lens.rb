module Pxfinder
  module Models
    class Lens < Sequel::Model(:lenses)
      many_to_one :manufacturer
      many_to_one :sensor_type
      one_to_many :photos

      plugin :column_conflicts
      plugin :json_serializer

      include Utils

      def self.find_or_create_by(lens_model:, make: nil)
        $log.info("Lens: find_or_create_by make: #{make}, model: #{lens_model}")

        make_name = Pxfinder::Photography.lens_make(make) \
                      || Pxfinder::Photography.lens_make(lens_model)
        manufacturer = Manufacturer.find_or_create(name: make_name) unless make_name.nil?
        unique_name = Photography.remove_make_from_name(lens_model, make_name).downcase.strip
        name = Photography.pretty_name(lens_model, make_name)

        Lens.find_or_create(lens_model: unique_name) do |c|
          c.name = name
          c.manufacturer_id = manufacturer.id if manufacturer
        end
      end

      def self.make_name(make: nil, lens_model:)
        Pxfinder::Photography.lens_make(make) \
          || Pxfinder::Photography.lens_make(lens_model)
      end

    end
  end
end
