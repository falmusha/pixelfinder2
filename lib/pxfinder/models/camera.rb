module Pxfinder
  module Models
    class Camera < Sequel::Model
      many_to_one :manufacturer
      many_to_one :sensor_type
      one_to_many :photos

      plugin :column_conflicts
      plugin :json_serializer

      def self.find_or_create_by(camera_model:, make: nil)
        $log.info("Camera: find_or_create_by make: #{make}, model: #{camera_model}")

        helpers = Pxfinder::Utils::ModelNameHelpers

        manufacturer = Manufacturer.find_or_create_by(model_name: camera_model,
                                                      make: make)
        model_without_make = helpers.remove_make_from_name(camera_model,
                                                           manufacturer)
        pretty_name = helpers.pretty_name(camera_model, manufacturer)

        Camera.find_or_create(camera_model: model_without_make.downcase) do |c|
          c.name = pretty_name
          c.manufacturer_id =  manufacturer.id if manufacturer
        end
      end

      def self.refind_manufacturer()
        count = 0
        where(manufacturer_id: nil).each do |camera|
          manufacturer = \
            Manufacturer.find_or_create_by(model_name: camera.camera_model)
          if manufacturer
            camera.manufacturer_id = manufacturer.id
            camera.save
            count += 1
          end
        end

        $log.info("Camera: refind_manufacturer: found #{count}")
      end

      def self.rename_models()
        all.each do |camera|
          pn = Pxfinder::Utils::ModelNameHelpers.pretty_name(camera.name,
                                                             camera.manufacturer)
          if camera.name.downcase != pn.downcase
            camera.name = pn
            camera.save
          end
        end
      end
    end
  end
end
