class Image < ApplicationRecord
  belongs_to :creator
  belongs_to :camera
  belongs_to :lens

  validates_uniqueness_of :page_url
  validates_uniqueness_of :image_url
  validates_uniqueness_of :thumbnail_url
end
