require 'oauth'
require 'json'

module Pxfinder
  module Crawler
    class FHPxClient < BaseClient
      NAME              = '500px'
      BASE_URL          = 'https://api.500px.com'.freeze
      PHOTO_URL_BASE    = 'https://500px.com/photo'.freeze
      LARGE_PHOTO_PARAM = 1080
      SMALL_PHOTO_PARAM = 30

      def initialize
        $log.info('FiveHundredPxClient:get_access_token: Initializing Consumer')

        consumer = OAuth::Consumer.new(
          configatron.fhpx_consumer_key,
          configatron.fhpx_consumer_secret,
          site:               BASE_URL,
          request_token_path: '/v1/oauth/request_token',
          access_token_path:  '/v1/oauth/access_token',
          authorize_path:     '/v1/oauth/authorize'
        )

        request_token = consumer.get_request_token()
        $log.info("FHPxClient:Request URL: #{request_token.authorize_url}")
        @access_token = consumer.get_access_token(request_token, {},
          x_auth_mode: 'client_auth',
          x_auth_username: configatron.fhpx_username,
          x_auth_password: configatron.fhpx_password)
      end

      def fetch(per_page, page)
        photos = []
        params = 'featrue=popular' \
          "&page=#{page}" \
          "&rpp=#{per_page}" \
          "&image_size=#{LARGE_PHOTO_PARAM},#{SMALL_PHOTO_PARAM}" \
          "&only=#{valid_categories}"

        response = @access_token.get("/v1/photos?#{params}").body
        photos = JSON.parse(response)['photos']

        photos
      end

      private

      def add_exif_to(raw_photo)
        return nil unless has_exif_tags?(raw_photo)

        photo = format_exif(raw_photo)
        photo[:creator] = if raw_photo['user']['fullname'].empty?
                            raw_photo['user']['username']
                          else
                            raw_photo['user']['fullname']
                          end
        urls = raw_photo['images']
        urls.each do |url|
          photo[:photo_url] = url['url'] if url['size'] == LARGE_PHOTO_PARAM
          photo[:thumbnail_url] = url['url'] if url['size'] == SMALL_PHOTO_PARAM
        end
        photo[:page_url] = photo_url(raw_photo['id'])
        photo[:exif] = raw_photo
        photo[:source] = NAME

        photo
      end

      def format_exif(exif)
        {
          camera: {make: nil, model: exif['camera']},
          lens: {make: nil, model: exif['lens']},
          shutter_speed: exif['shutter_speed'],
          aperture: exif['aperture'],
          iso: exif['iso'].to_i,
          focal_length: exif['focal_length'].to_i
        }
      end

      def required_exif_tag
        %w(camera lens shutter_speed aperture iso focal_length)
      end

      def photo_url(id)
        "#{PHOTO_URL_BASE}/#{id}"
      end

      def valid_categories
        ['Abstract', 'Aerial', 'Animals', 'Food', 'Landscapes', 'Macro',
         'Nature', 'Still Life'].join(',').gsub(' ', '%20')
      end
    end
  end
end
