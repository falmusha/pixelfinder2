require 'pixelfinder/image_client/image_source_client'
require 'pixelfinder/image_client/flickr_client/flickr_api_wrapper'

module PixelFinder
  module ImageClient

    class FlickrClient < ImageSourceClient

      def initialize
        FlickrApiWrapper.init
      end

      def fetch_photos(num_of_photos)
        images = []
        total_requested = 0
        while images.length < num_of_photos do
          per_page = total_requested.gcd(num_of_photos - images.length)
          page = 1 + (total_requested / per_page)
          photos = FlickrApiWrapper.interesting_photos(per_page, page)
          images.concat(images(photos))
          total_requested += per_page
        end
        images
      end

      def images(photos)
        images = []
        image = {}
        photos.each do |photo|
          image = build_image(photo)
          images << image unless image.empty?
        end
        images
      end

      def build_image(photo)
        info = FlickrApiWrapper.info(photo)
        urls = FlickrApiWrapper.urls(info)
        raw_exif = FlickrApiWrapper.exif(photo)

        return {} if info.nil? || urls.empty? || raw_exif.nil?

        exif = parse_exif(raw_exif)
        return {} unless exif_has_required_tags?(exif)

        image = urls.merge(format_exif(exif))
        image[:creator] = info['owner']['realname'].presence
        image[:creator] ||= info['owner']['username']
        image[:exif] = raw_exif
        image
      end

      def parse_exif(raw_exif)
        exif = {}
        raw_exif['exif'].each do |elem|
          key = elem['tag']
          value = elem['raw'].strip.downcase
          exif[key] = value
        end
        exif
      end

      def format_exif(exif)
        { camera: { make: exif['Make'], model: exif['Model'] },
          lens: { make: exif['LensMake'], model: exif['LensModel'] },
          shutter_speed: exif['ExposureTime'],
          aperture: exif['FNumber'],
          iso: exif['ISO'].to_i,
          focal_length: exif['FocalLength'].to_i }
      end

      def exif_has_required_tags?(exif)
        tags = ['Make', 'Model', 'LensModel', 'ExposureTime', 'FNumber',
                'ISO', 'FocalLength']
        tags.any? { |k| exif.key?(k) && exif[k].present? }
      end

    end
  end
end
