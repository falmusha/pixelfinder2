class SensorType < ApplicationRecord
  validates_uniqueness_of :name
end
