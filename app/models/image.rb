class Image < ApplicationRecord
  belongs_to :creator
  belongs_to :camera
  belongs_to :lens

  validates_uniqueness_of :url
end
