class Manufacturer < ApplicationRecord
  validates_uniqueness_of :name
end
