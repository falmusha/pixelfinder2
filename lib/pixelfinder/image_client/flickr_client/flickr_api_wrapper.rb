require 'flickraw'

module PixelFinder
  module ImageClient

    class FlickrApiWrapper

      class << self

        def init
          FlickRaw.api_key = Rails.application.secrets.flickr_api_key
          FlickRaw.shared_secret = Rails.application.secrets.flickr_shared_secret
        end

        def interesting_photos(per_page, page)
          flickr.interestingness.getList(per_page: per_page, page: page)
        end
        
        def info(photo)
          begin
            info = flickr.photos.getInfo(photo_id: photo.id,
                                         secret: photo.secret)
          rescue FlickRaw::FailedResponse => e
            Rails.logger.warn("FlickrApiWrapper::#{e.class}::#{e.message}")
            return nil
          end
          info
        end

        def urls(info)
          urls = { page_url:      FlickRaw.url_photopage(info),
                   image_url:     FlickRaw.url_b(info),
                   thumbnail_url: FlickRaw.url_t(info) }
          urls
        end

        def exif(photo)
          begin
            raw_exif = flickr.photos.getExif(photo_id: photo.id,
                                             secret: photo.secret)
          rescue FlickRaw::FailedResponse => e
            Rails.logger.warn("FlickrApiWrapper::#{e.class}::#{e.message}")
            return nil
          end
          return raw_exif
        end

      end
    end
  end
end
