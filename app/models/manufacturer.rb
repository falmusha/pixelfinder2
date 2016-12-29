class Manufacturer < ApplicationRecord
  has_many :cameras

  validates_uniqueness_of :name
end
