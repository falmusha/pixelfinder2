require 'pixelfinder/image_client/image_client_factory'
require 'pixelfinder/image_client/image_saver'

module PixelFinder
  module ImageClient

    class ImageCrawler
      class << self
        def crawl(source, num_of_images)
          client = ImageClientFactory.client_for(source)

          Rails.logger.info("Trying to crawl #{num_of_images} from #{source}")
          start_time = Time.now

          images = client.fetch_photos(num_of_images)
          ImageSaver.save_images(images)

          total_time = Time.now - start_time
          Rails.logger.info(
            "Took #{total_time}s to save #{num_of_images} images from #{source}"
          )
        end
      end

    end

  end
end
