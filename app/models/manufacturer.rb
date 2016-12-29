class Manufacturer < ApplicationRecord
  has_many :cameras
  has_many :lenses

  validates_uniqueness_of :name
end
