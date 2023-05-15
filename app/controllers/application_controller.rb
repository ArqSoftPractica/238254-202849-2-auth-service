require 'dotenv'

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

  before do
    content_type :json
  end
end
