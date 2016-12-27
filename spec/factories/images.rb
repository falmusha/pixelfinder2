FactoryGirl.define do
  factory :image do
    url 'https://drscdn.500px.org/photo/120874651/m%3D900_k%3D1_a%3D1/ecfc525e2b9185fdb8b2fde096fd21b3'
    creator_id 265076
    camera_id 1 # NIKON D810
    lens_id 1 # 300.0 mm f/4.0
    aperture 'f/5.6'
    shutter_speed '1/1250'
    iso 400
    focal_length 300
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
