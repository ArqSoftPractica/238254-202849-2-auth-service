require 'dotenv'
require 'sinatra/cross_origin'

class ApplicationController < Sinatra::Base
  Dotenv.load

  set :port, ENV['PORT'] || 80
  require 'sinatra/reloader' if development?
  require 'hashie'

  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
    enable :reloader
    also_reload 'app/**/*.rb'
    also_reload 'config/**/*.rb'
    also_reload './**/*.rb'
    also_reload './*.rb'
  end

  configure do
    enable :cross_origin
    set :allow_origin, :any
    set :allow_methods, %i[get post put delete]
    set :allow_headers, ['Content-Type']
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = '*'
    response.headers['Access-Control-Allow-Headers'] = '*'
  end

  options '*' do
    response.headers['Allow'] = 'GET, POST, PUT, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization, Accept'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    200
  end
end
