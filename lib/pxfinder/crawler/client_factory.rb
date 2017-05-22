module Pxfinder
  module Crawler
    class ClientSourceInvalid < RuntimeError
    end

    class Factory
      def self.client_for(source)
        case source
        when FlickrClient::NAME
          FlickrClient.new
        when FHPxClient::NAME
          FHPxClient.new
        else
          raise ClientSourceInvalid, "no factory for #{source}"
        end
      end
    end
  end
end
