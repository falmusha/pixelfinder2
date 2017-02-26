require 'pixelfinder/image_client/image_crawler'

namespace :pixelfinder do
  namespace :save_images do

    desc "Save images from Flickr"
    task :from_flickr, [:num_of_images] => [:environment] do |t, args|
      PixelFinder::ImageClient::ImageCrawler.crawl(
        'flickr',
        args[:num_of_images].to_i
      )
    end

    desc "Save images from 500PX"
    task :from_500px, [:num_of_images] => [:environment] do |t, args|
      PixelFinder::ImageClient::ImageCrawler.crawl(
        '500px',
        args[:num_of_images].to_i
      )
    end

  end
end
