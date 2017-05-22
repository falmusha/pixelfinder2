module Pxfinder
  module Crawler
    class FlickrClient < BaseClient
      NAME = 'Flickr'

      def initialize
        FlickrApiWrapper.init
      end

      def fetch(per_page, page)
        FlickrApiWrapper.interestingness(per_page, page)
      end

      private

      def add_exif_to(raw_photo)
        info = FlickrApiWrapper.info(raw_photo)
        return nil if info.nil? || info["people"]["haspeople"] != 0

        urls = FlickrApiWrapper.urls(info)
        return nil if urls.empty?

        exif_response = FlickrApiWrapper.exif(raw_photo)
        return nil if exif_response.nil?

        tag_value_exif = extract_tag_value(exif_response)
        return nil unless has_exif_tags?(tag_value_exif)

        formatted_exif = format_exif(exif_response, tag_value_exif)
        photo = urls.merge(formatted_exif)
        photo[:creator] = if info['owner']['realname'].empty?
                            info['owner']['username']
                          else
                            info['owner']['realname']
                          end
        exif_response = exif_response.to_hash.select do |k, v|
          ["id", "camera", "exif"].include?(k)
        end
        photo[:exif] = {
          id: exif_response["id"],
          camera: exif_response["camera"],
          raw: exif_response["exif"].map(&:to_hash)
        }
        photo[:source] = NAME

        photo
      end

      def extract_tag_value(exif_response)
        exif_response.exif.reduce({}) do |hash, elem|
          hash[elem['tag']] = elem['raw']
          hash
        end
      end

      def format_exif(exif_response, tag_value_exif)
        exif = tag_value_exif

        formatted = {
          camera: { make: exif['Make'], model: exif['Model'] },
          # LensMake is not required, might not be in hash
          lens: { make: exif['LensMake'] && exif['LensMake'],
                  model: exif['LensModel']},
          shutter_speed: exif['ExposureTime'],
          aperture: exif['FNumber'],
          iso: exif['ISO'].to_i,
          focal_length: exif['FocalLength'].to_i
        }

        if exif_response['camera'].empty?
          formatted[:camera][:name] = "#{exif['Make']} #{exif['Model']}".strip
        else
          formatted[:camera][:name] = exif_response['camera']
        end

        formatted[:lens][:name] = "#{exif['LensMake']} #{exif['LensModel']}".strip

        formatted
      end

      def required_exif_tag
        %w(Make Model LensModel ExposureTime FNumber ISO FocalLength)
      end
    end
  end
end
