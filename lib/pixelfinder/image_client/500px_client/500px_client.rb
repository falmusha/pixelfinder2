require 'pixelfinder/image_client/image_source_client'
require 'rubygems'
require 'oauth'
require 'multi_json'

CONSUMER_KEY = Rails.application.secrets.five00px_consumer_key
CONSUMER_SECRET = Rails.application.secrets.five00px_consumer_secret
USERNAME = Rails.application.secrets.five00px_username
PASSWORD = Rails.application.secrets.five00px_password

BASE_URL = 'https://api.500px.com'

module PixelFinder
  module ImageClient

    class FiveHundredPxClient < ImageSourceClient

      def initialize
        p "get_access_token: Initializing Consumer"
        consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
          :site               => BASE_URL,
          :request_token_path => "/v1/oauth/request_token",
          :access_token_path  => "/v1/oauth/access_token",
          :authorize_path     => "/v1/oauth/authorize"})

        request_token = consumer.get_request_token()
        p "Request URL: #{request_token.authorize_url}"
        @access_token = consumer.get_access_token(
          request_token, {}, { :x_auth_mode => 'client_auth',
                               :x_auth_username => USERNAME,
                               :x_auth_password => PASSWORD })
      end

      def fetch_photos(num_of_photos)
        params = "featrue=popular&rpp=#{num_of_photos}&image_size=1080,30"
        photos = MultiJson.decode(@access_token.get("/v1/photos?#{params}").body)['photos']
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

        image[:page_url] = "https://500px/photo/#{photo['id']}"
        #image[:page_url] = photo['url']
        urls = photo['images']
        urls.each do |url|
          image[:image_url] = url['url'] if url['size'] == 1080
          image[:thumbnail_url] = url['url'] if url['size'] == 30
        end
        image[:exif] = photo
        image
      end

      def format_exif(exif)
        { camera: { make: exif['camera'].split.first, model: exif['camera'] },
          lens: { make: {}, model: exif['lens'] },
          shutter_speed: exif['shutter_speed'],
          aperture: exif['aperture'],
          iso: exif['iso'].to_i,
          focal_length: exif['focal_length'].to_i }
      end

      def exif_has_required_tags?(exif)
        tags = ['camera', 'lens', 'shutter_speed', 'aperture',
                'iso', 'focal_length', 'user']
        tags.any? { |k| exif.key?(k) && exif[k].present? }
      end

    end
  end
end

#def get_access_token
#  p "get_access_token: Initializing Consumer"
#  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, {
#  :site               => BASE_URL,
#  :request_token_path => "/v1/oauth/request_token",
#  :access_token_path  => "/v1/oauth/access_token",
#  :authorize_path     => "/v1/oauth/authorize"})
#
#  request_token = consumer.get_request_token()
#  p "Request URL: #{request_token.authorize_url}"
#  access_token = consumer.get_access_token(request_token, {}, { :x_auth_mode => 'client_auth', :x_auth_username => USERNAME, :x_auth_password => PASSWORD })
#  access_token
#end

#access_token = get_access_token
#p "token: #{access_token.token}"
#p "secret: #{access_token.secret}"


#p access_token.get('/v1/photos.json').body
#p MultiJson.decode(access_token.get('/v1/users.json').body).inspect
