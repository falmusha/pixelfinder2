class Creator < ApplicationRecord
  has_many :images

  validates_uniqueness_of :name
end
