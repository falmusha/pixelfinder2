FactoryGirl.define do
  factory :camera do
    model 'Nikon D810'
    resolution 1.5
    association :manufacturer
    association :sensor_type
    mount_id 1
  end
end
