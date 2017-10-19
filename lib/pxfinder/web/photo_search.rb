module Pxfinder
  module Web
    class PhotoSearch
      PHOTOS_PER_PAGE = 50

      attr_reader :filters, :page

      def initialize(params)
        @filters = extract_filters(params)
        @page = params['page'].to_i
      end

      def json_results
        results.to_json(only: %i[id page_url thumbnail_url photo_url source],
                        include: { creator: { only: %i[id name] } })
      end

      def results
        Pxfinder::Models::Photo.where(@filters).eager(:creator)
                               .offset((@page - 1) * PHOTOS_PER_PAGE)
                               .limit(PHOTOS_PER_PAGE)
                               .order(:camera_id)
      end

      def extract_filters(params)
        {
          camera_id: id_value(params, 'camera_id'),
          lens_id: id_value(params, 'lens_id'),
          focal_length: range_value(params, 'focal_length'),
          iso: range_value(params, 'iso'),
          aperture: range_value(params, 'aperture', :flaot),
          shutter_speed: format_shutter(params)
        }.reject { |_, v| v.nil? }
      end

      private

      def id_value(params, key)
        params[key].nil? ? nil : params[key].to_i
      end

      def range_value(params, attr_name, value_type = :int)
        min = params["min_#{attr_name}"]
        max = params["max_#{attr_name}"]
        return if min.nil? || max.nil?

        if value_type == :float
          min = min.to_f
          max = max.to_f
        else
          min = min.to_i
          max = max.to_i
        end

        min == max ? min : min..max
      end

      def format_shutter(params)
        min = Pxfinder::Utils.shutter_speed_from(params['min_shutter'])
        max = Pxfinder::Utils.shutter_speed_from(params['max_shutter'])
        return if min.nil? || max.nil?

        min == max ? min : min..max
      end
    end
  end
end
