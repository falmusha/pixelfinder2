module Pxfinder
  module Models
    class Lens < Sequel::Model(:lenses)
      many_to_one :manufacturer
      many_to_one :sensor_type
      one_to_many :photos

      plugin :column_conflicts
      plugin :json_serializer

      def self.find_or_create_by(lens_model:, make: nil)
        helpers = Pxfinder::Utils::ModelNameHelpers

        manufacturer = Manufacturer.find_or_create_by(model_name: lens_model,
                                                      make: make)
        model_without_make = helpers.remove_make_from_name(lens_model,
                                                           manufacturer)
        pretty_name = helpers.pretty_name(lens_model, manufacturer)

        Lens.find_or_create(lens_model: model_without_make.downcase.strip) do |c|
          c.name = pretty_name
          c.manufacturer_id =  manufacturer.id if manufacturer
        end
      end
    end
  end
end
