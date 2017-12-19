module Pxfinder
  module Models
    class Camera < Sequel::Model
      many_to_one :manufacturer
      many_to_one :sensor_type
      one_to_many :photos

      plugin :column_conflicts
      plugin :json_serializer

      include Utils

      def self.find_or_create_by(camera_model:, make: nil)
        $log.info("Camera: find_or_create_by make: #{make}, model: #{camera_model}")

        make_name = make_name(make: make, camera_model: camera_model)
        manufacturer = Manufacturer.find_or_create(name: make_name) unless make_name.nil?
        unique_name = Photography.remove_make_from_name(camera_model, make_name).downcase.strip
        name = Photography.pretty_name(camera_model, make_name)

        Camera.find_or_create(camera_model: unique_name) do |c|
          c.name = name
          c.manufacturer_id = manufacturer.id if manufacturer
        end
      end

      def self.make_name(make: nil, camera_model:)
        Pxfinder::Photography.camera_make(make) \
          || Pxfinder::Photography.camera_make(camera_model)
      end

      def self.refind_manufacturer
        count = 0
        where(manufacturer_id: nil).each do |camera|
          make_name = make_name(camera_model: camera.camera_model)
          next if make_name.nil?
          manufacturer = Manufacturer.find_or_create(name: make_name)
          camera.manufacturer_id = manufacturer.id
          camera.save
          count += 1
        end

        $log.info("Camera: refind_manufacturer: found #{count}")
      end

      def self.rename_models
        all.each do |camera|
          pn = Pxfinder::Utils::ModelNameHelpers.pretty_name(camera.name, camera.manufacturer)
          if camera.casecmp(pn) != 0
            camera.name = pn
            camera.save
          end
        end
      end
    end
  end
end
