require 'flickraw'

module Pxfinder
  module Crawler
    class FlickrApiWrapper
      def self.init
        FlickRaw.api_key       = configatron.flickr_api_key
        FlickRaw.shared_secret = configatron.flickr_shared_secret
      end

      def self.interestingness(per_page, page)
        $log.info("FlickrApiWrapper:interestingness: Get #{per_page} " \
          "interesting photos out of page #{page}")

        # get the day before yesterday date in UTC
        two_days_ago = Time.now.utc.to_date.prev_day(2).strftime('%Y-%m-%d')
        photos = flickr.interestingness.getList(per_page: per_page, page: page,
                  date: two_days_ago, extras: 'tags')

        photos
      end

      def self.info(photo)
        begin
          info = flickr.photos.getInfo(photo_id: photo['id'],
                                       secret: photo['secret'])
        rescue FlickRaw::FailedResponse, Net::OpenTimeout => e
          $log.warn("FlickrApiWrapper:info: #{e.class}::#{e.message}")
          return nil
        end

        info
      end

      def self.urls(info)
        urls = { page_url:      FlickRaw.url_photopage(info),
                 photo_url:     FlickRaw.url_b(info),
                 thumbnail_url: FlickRaw.url_n(info) }
        urls
      end

      def self.exif(photo)
        begin
          raw_exif = flickr.photos.getExif(photo_id: photo.id,
                                           secret: photo.secret)
        rescue FlickRaw::FailedResponse, Net::OpenTimeout => e
          $log.warn("FlickrApiWrapper:exif: #{e.class}::#{e.message}")
          return nil
        end

        raw_exif
      end
    end
  end
end
