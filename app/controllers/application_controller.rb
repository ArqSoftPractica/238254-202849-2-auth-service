require 'dotenv'

class ApplicationController < Sinatra::Base
  Dotenv.load

  set :port, ENV['PORT'] || 80
  require 'sinatra/reloader' if development?
  require 'hashie'

  register Sinatra::ActiveRecordExtension

  configure :development do
    register Sinatra::Reloader
  end
end
