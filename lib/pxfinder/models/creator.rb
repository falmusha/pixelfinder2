module Pxfinder
  module Models
    class Creator < Sequel::Model
      one_to_many :photos
    end
  end
end
