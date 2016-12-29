FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |n| "manufacturer-#{n}" }
  end
end
