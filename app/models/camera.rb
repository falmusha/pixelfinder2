class Camera < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :sensor_type
  has_many :images

  validates_uniqueness_of :model, scope: :manufacturer_id
end
