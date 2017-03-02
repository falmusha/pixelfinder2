class Camera < ApplicationRecord
  belongs_to :manufacturer, optional: true
  belongs_to :sensor_type, optional: true
  has_many :images

  validates_uniqueness_of :model, scope: :manufacturer_id
end
