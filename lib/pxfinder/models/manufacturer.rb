module Pxfinder
  module Models
    class Manufacturer < Sequel::Model
      one_to_many :lenses, class: Lens
      one_to_many :cameras
    end
  end
end
