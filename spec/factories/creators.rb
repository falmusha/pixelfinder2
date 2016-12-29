FactoryGirl.define do
  factory :creator do
    sequence(:name) {|n| "creator#{n}"}
    email 'creator@gmail.com'
    website 'creator.com'
  end
end
