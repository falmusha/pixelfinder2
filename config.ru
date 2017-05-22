require 'rubygems'
require 'bundler/setup'

# add lib directory to load path
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), 'lib')

require 'pxfinder'

run Pxfinder::Web::App.freeze.app
