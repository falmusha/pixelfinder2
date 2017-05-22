require 'configatron'
require_relative '../config/configure'
require 'logger'

require 'pxfinder/models'
require 'pxfinder/crawler'
require 'pxfinder/web'
require 'pxfinder/utils'

require 'byebug' if ENV['RACK_ENV'] == 'development'

module Pxfinder
  $log = Logger.new(STDOUT)
end
