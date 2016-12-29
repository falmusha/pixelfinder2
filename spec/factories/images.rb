FactoryGirl.define do
  factory :image do
    association :creator
    association :camera
    association :lens
    aperture 'f/5.6'
    shutter_speed '1/1250'
    iso 400
    focal_length 300
    sequence(:page_url) { |n| "http://page_url#{n}" }
    sequence(:image_url) { |n| "http://image_url#{n}" }
    sequence(:thumbnail_url) { |n| "http://thumbnail_url#{n}" }
    exif {{
      'camera'        => 'NIKON D810',
      'lens'          => '300.0 mm',
      'aperture'      => 'f/5.6',
      'shutter_speed' => '1/1250',
      'iso'           => 400,
      'focal_length'  => 300
    }}
  end
end
