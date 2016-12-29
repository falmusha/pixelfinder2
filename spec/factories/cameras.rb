FactoryGirl.define do
  factory :camera do
    sequence(:model) { |n| "Camera#{n}" }
    resolution 1.5
    association :manufacturer
    association :sensor_type
    mount_id 1
  end
end
