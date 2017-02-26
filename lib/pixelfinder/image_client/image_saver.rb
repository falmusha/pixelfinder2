module PixelFinder
  module ImageClient

    class ImageSaver
      class << self
        def save_images(images)
          images.each do |image|
            save_image(image)
          end
        end

        def save_image(source_image)
          image = Image.new
          image.aperture = source_image[:aperture]
          image.shutter_speed = source_image[:shutter_speed]
          image.iso = source_image[:iso]
          image.focal_length = source_image[:focal_length]
          image.page_url = source_image[:page_url]
          image.image_url = source_image[:image_url]
          image.thumbnail_url = source_image[:thumbnail_url]
          image.camera = find_camera(source_image[:camera])
          image.lens = find_lens(source_image[:lens])
          image.creator = find_creator(source_image[:creator])
          image.exif = source_image[:exif]
          image.save
        end

        def find_camera(camera)
          if camera[:make].blank?
            camera = Camera.find_or_create_by(model: camera[:model])
          else
            manufacturer = find_manufacturer(camera[:make])
            Camera.find_or_create_by(model: camera[:model],
                                     manufacturer: manufacturer)
          end
          camera
        end

        def find_lens(lens)
          if lens[:make].blank?
            lens = Lens.find_or_create_by(model: lens[:model])
          else
            manufacturer = find_manufacturer(lens[:make])
            lens = Lens.find_or_create_by(model: lens[:model],
                                          manufacturer: manufacturer)
          end
          lens
        end

        def find_creator(name)
          Creator.find_or_create_by(name: name)
        end

        def find_manufacturer(name)
          Manufacturer.find_or_create_by(name: name)
        end
      end
    end
  end
end
