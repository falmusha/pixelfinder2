module PixelFinder
  module ImageClient

    class ImageSourceClient

      def fetch_photos(num_of_photos)
        raise NotImplementedError,
          "#{self.class.name} does not implement #{__method__}"
      end
    end
  end
end
