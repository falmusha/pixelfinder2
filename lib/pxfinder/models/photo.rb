module Pxfinder
  module Models
    class Photo < Sequel::Model
      many_to_one :camera
      many_to_one :lens
      many_to_one :creator
    end
  end
end
