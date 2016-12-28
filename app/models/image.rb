class Image < ApplicationRecord
  belongs_to :creator

  validates_uniqueness_of :url
end
