module Pxfinder
  module Crawler
    class BaseClient
      def get(num)
        photos = []
        requested = 0

        while photos.length < num do
          per_page, page = paging(num, requested, photos.length)
          processed = process(fetch(per_page, page))
          photos.concat(processed)
          requested += per_page

          $log.info("#{self.class.name}:get: required: #{num}, requested:" \
            " #{requested}, valid: #{photos.length}")
        end

        photos
      end

      def fetch(per_page, page)
        raise NotImplementedError,
              "#{self.class.name} does not implement #{__method__}"
      end

      private

      def process(raw_photos)
        processed = []
        raw_photos.each do |photo|
          with_exif = add_exif_to(photo)
          processed << with_exif unless with_exif.nil?
        end
        processed
      end

      def add_exif_to(raw_photo)
        raise NotImplementedError,
              "#{self.class.name} does not implement #{__method__}"
      end

      def required_exif_tag
        raise NotImplementedError,
              "#{self.class.name} does not implement #{__method__}"
      end

      def paging(required, requested, current)
        # TODO: paging strategy is not the best, it falls back to fetching
        # photos one by one if some don't have the EXIF permission. Subsequent
        # pages should be batched
        remaining = required - current
        per_page = requested.gcd(remaining)
        page = 1 + (requested / per_page)

        [per_page, page]
      end

      def has_exif_tags?(exif)
        required_exif_tag.all? { |k| exif.key?(k) && !exif[k].to_s.empty? }
      end
    end
  end
end
