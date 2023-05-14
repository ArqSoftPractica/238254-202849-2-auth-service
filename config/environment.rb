require 'bundler'
require 'bundler/setup'

Bundler.require(:default, ENV.fetch('RACK_ENV', 'development'))

default :autoload_paths, %w[
  controllers
  models
  lib/middlewares
]

require_all 'app'
