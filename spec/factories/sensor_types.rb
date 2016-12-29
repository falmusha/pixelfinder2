FactoryGirl.define do
  factory :sensor_type do
    sequence(:name) { |n| "sensor-#{n}" }
  end
end
