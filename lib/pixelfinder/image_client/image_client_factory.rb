require 'pixelfinder/image_client/flickr_client/flickr_client'

module PixelFinder
  module ImageClient

    class ClientSourceInvalid < Exception; end

    class ImageClientFactory
      def self.client_for(source)
        case source
        when 'flickr'
          FlickrClient.new
        else
          raise ClientSourceInvalid, "no factory for #{source}"
        end
      end
    end
  end
end
