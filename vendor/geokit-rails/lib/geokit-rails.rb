# Load modules and classes needed to automatically mix in ActiveRecord and 
# ActionController helpers.  All other functionality must be explicitly 
# required.
#
# Note that we don't explicitly require the geokit gem. 
# You should specify gem dependencies in your config/environment.rb: config.gem "geokit"
#
require 'geokit'
if defined? Geokit
  # rather than unvendor this, let's try to get rid of the acts_as_mappable dependency (?)
  require File.expand_path('../geokit-rails/defaults', __FILE__)
  require File.expand_path('../geokit-rails/adapters/abstract', __FILE__)
  require File.expand_path('../geokit-rails/acts_as_mappable', __FILE__)
  require File.expand_path('../geokit-rails/ip_geocode_lookup', __FILE__)
  
  # Automatically mix in distance finder support into ActiveRecord classes.
  ActiveRecord::Base.send :include, GeoKit::ActsAsMappable
  
  # # Automatically mix in ip geocoding helpers into ActionController classes.
  # ActionController::Base.send :include, GeoKit::IpGeocodeLookup
else
  message=%q(WARNING: geokit-rails requires the Geokit gem. You either don't have the gem installed,
or you haven't told Rails to require it. If you're using a recent version of Rails: 
  config.gem "geokit" # in config/environment.rb
and of course install the gem: sudo gem install geokit)
  puts message
  Rails.logger.error message
end