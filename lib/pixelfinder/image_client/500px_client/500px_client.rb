require 'pixelfinder/image_client/image_source_client'
require 'rubygems'
require 'oauth'
require 'json'

module PixelFinder
  module ImageClient

    class FiveHundredPxClient < ImageSourceClient

      BASE_URL = 'https://api.500px.com'
      LARGE_IMAGE_PARAM = 1080
      SMALL_IMAGE_PARAM = 30

      def initialize
        Rails.logger.info("500PxClient::get_access_token: Initializing Consumer")
        consumer = OAuth::Consumer.new(
          Rails.application.secrets._500px_consumer_key,
          Rails.application.secrets._500px_consumer_secret,
          { :site               => BASE_URL,
            :request_token_path => "/v1/oauth/request_token",
            :access_token_path  => "/v1/oauth/access_token",
            :authorize_path     => "/v1/oauth/authorize"})

        request_token = consumer.get_request_token()
        Rails.logger.info("500PxClient::Request URL: #{request_token.authorize_url}")
        @access_token = consumer.get_access_token(
          request_token, {},
          { :x_auth_mode => 'client_auth',
            :x_auth_username => Rails.application.secrets._500px_username,
            :x_auth_password => Rails.application.secrets._500px_password })
      end

      def fetch_photos(num_of_photos)
        params = "featrue=popular&rpp=#{num_of_photos}"\
          "&image_size=#{LARGE_IMAGE_PARAM},#{SMALL_IMAGE_PARAM}"
        photos = JSON.parse(@access_token.get("/v1/photos?#{params}").body)['photos']
        puts photos
        images(photos)
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
        return {} unless exif_has_required_tags?(photo)

        image = format_exif(photo)

        creator = photo['user']['fullname'].presence || photo['user']['username']
        image[:creator] = creator

        urls = photo['images']
        urls.each do |url|
          image[:image_url] = url['url'] if url['size'] == LARGE_IMAGE_PARAM
          image[:thumbnail_url] = url['url'] if url['size'] == SMALL_IMAGE_PARAM
        end
        image[:page_url] = "https://500px.com/photo/#{photo['id']}"
        image[:exif] = photo
        image
      end

      def format_exif(exif)
        camera = find_camera(exif['camera'])
        { camera: camera,
          lens: { make: {}, model: exif['lens'].strip.downcase },
          shutter_speed: exif['shutter_speed'].strip.downcase,
          aperture: exif['aperture'].strip.downcase,
          iso: exif['iso'].to_i,
          focal_length: exif['focal_length'].to_i }
      end

      def find_camera(camera)
        camera.strip!
        camera.downcase!
        make = camera.split.first
        if Manufacturer.exists?(name: make)
          { make: make, model: camera }
        else
          { make: {}, model: camera }
        end
      end

      def exif_has_required_tags?(exif)
        tags = ['camera', 'lens', 'shutter_speed', 'aperture',
                'iso', 'focal_length', 'user']
        tags.all? { |k| exif.key?(k) && exif[k].present? }
      end

    end
  end
end
