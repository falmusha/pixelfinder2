require 'configatron'
require_relative '../config/configure'
require 'logger'

require 'pxfinder/utils'
require 'pxfinder/photography'
require 'pxfinder/models'
require 'pxfinder/crawler'
require 'pxfinder/web'

require 'byebug' if ENV['RACK_ENV'] == 'development'

module Pxfinder
  $log = Logger.new(STDOUT)
end
