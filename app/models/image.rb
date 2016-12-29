class Image < ApplicationRecord
  belongs_to :creator
  belongs_to :camera

  validates_uniqueness_of :url
end
