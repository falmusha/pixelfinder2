FactoryGirl.define do
  factory :lens do
    sequence(:model) { |n| "Lens-#{n}" }
    min_aperture 1.5
    max_aperture 1.5
    min_focal_length 1
    max_focal_length 1
    association :manufacturer
    association :sensor_type
    mount_id 1
  end
end
