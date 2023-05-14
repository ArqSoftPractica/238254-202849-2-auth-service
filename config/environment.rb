require 'bundler'
require 'bundler/setup'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))

require_all 'app'
