require 'pxfinder/crawler/client_factory'
require 'pxfinder/crawler/base_client'
require 'pxfinder/crawler/flickr_api_wrapper'
require 'pxfinder/crawler/flickr_client'
require 'pxfinder/crawler/fhpx_client'

module Pxfinder
  module Crawler
    include Pxfinder::Models

    def self.crawl(source, num_of_photos)
      client = Factory.client_for(source)

      $log.info("Trying to crawl #{num_of_photos} from #{source}")
      start_time = Time.now

      photos = client.get(num_of_photos)
      save_photos(photos)

      total_time = Time.now - start_time
      $log.info("Took #{total_time}s to save #{num_of_photos} " \
        "photos from #{source}")
    end

    def self.save_photos(photos)
      photos.each do |photo|
        save_photo(photo)
      end
    end

    def self.save_photo(source_photo)
      photo               = Photo.new
      photo.aperture      = aperture(source_photo[:aperture])
      photo.shutter_speed = shutter_speed(source_photo[:shutter_speed])
      photo.iso           = source_photo[:iso]
      photo.focal_length  = source_photo[:focal_length]
      photo.page_url      = source_photo[:page_url]
      photo.photo_url     = source_photo[:photo_url]
      photo.thumbnail_url = source_photo[:thumbnail_url]
      photo.camera        = find_camera(source_photo[:camera])
      photo.lens          = find_lens(source_photo[:lens])
      photo.creator       = find_creator(source_photo[:creator])
      photo.exif          = source_photo[:exif]
      photo.source        = source_photo[:source]

      if photo.valid?
        photo.save
      else
        errs = photo.errors.to_s
        $log.error("Crawler:save_photo Photo not valid, errors: #{errs}")
      end
    end

    def self.aperture(aperture_str)
      Pxfinder::Utils.aperture_from(aperture_str)
    end

    def self.shutter_speed(shutter_speed_str)
      Pxfinder::Utils.shutter_speed_from(shutter_speed_str)
    end

    def self.find_camera(camera)
      Camera.find_or_create_by(camera_model: camera[:model],
                               make: camera[:make])
    end

    def self.find_lens(lens)
      Lens.find_or_create_by(lens_model: lens[:model], make: lens[:make])
    end

    def self.find_creator(name)
      Creator.find_or_create(name: name)
    end
  end
end
