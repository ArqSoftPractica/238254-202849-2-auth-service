require_relative 'config/environment'
require 'sinatra/activerecord/rake'
require 'pry'

namespace :db do
  task :load_config do
    require './app'
  end
end

task :console do
  Pry.start
end
