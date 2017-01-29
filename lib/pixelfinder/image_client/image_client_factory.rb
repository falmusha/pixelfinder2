require 'pixelfinder/image_client/flickr_client/flickr_client'
require 'pixelfinder/image_client/500px_client/500px_client'

module PixelFinder
  module ImageClient

    class ClientSourceInvalid < Exception; end

    class ImageClientFactory
      def self.client_for(source)
        case source
        when 'flickr'
          FlickrClient.new
        when '500px'
          FiveHundredPxClient.new
        else
          raise ClientSourceInvalid, "no factory for #{source}"
        end
      end
    end
  end
end
