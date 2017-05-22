# ------------------------------------------------------------------------------
#
#   Defaults configurations
#
# ------------------------------------------------------------------------------

# Flickr and 500px keys
configatron.flickr_api_key       = ENV['FLICKR_API_KEY']
configatron.flickr_shared_secret = ENV['FLICKR_SHARED_SECRET']
configatron.fhpx_consumer_key    = ENV['FHPX_CONSUMER_KEY']
configatron.fhpx_consumer_secret = ENV['FHPX_CONSUMER_SECRET']
configatron.fhpx_username        = ENV['FHPX_USERNAME']
configatron.fhpx_password        = ENV['FHPX_PASSWORD']

# ------------------------------------------------------------------------------
#
#   Environment specific configurations
#
# ------------------------------------------------------------------------------
#
case ENV['RACK_ENV']
when 'development'
  configatron.db_url = 'postgresql://localhost/pxfinder_dev'
when 'test'
  configatron.db_url = 'postgresql://localhost/pxfinder_test'
when 'production'
  configatron.db_url = ENV['DATABASE_URL']
end
