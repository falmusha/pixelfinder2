class Image < ApplicationRecord
  validates_uniqueness_of :url
end
