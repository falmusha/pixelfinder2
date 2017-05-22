require 'pxfinder/utils/model_name_helpers'

module Pxfinder
  module Utils
    def self.aperture_from(str)
      return if str.nil? || str.empty?

      matches = /\d+(\.\d+)?/i.match(str)
      matches ? matches[0].to_f.round(1) : nil
    end

    # get shutter speed in ms
    def self.shutter_speed_from(str)
      return if str.nil? || str.empty?
      if %r{\d+\/(\d+)}i.match?(str) # matching 1/5000 s
        denom = %r{\d+\/(\d+)}i.match(str)[1].to_f
        ((1.0 / denom) * 1000.0).round(2)
      elsif /\d+(\.\d+)?/i.match?(str)
        ms = /\d+(\.\d+)?/i.match(str)[0].to_f * 1000.0
        ms.round(2)
      end
    end
  end
end
