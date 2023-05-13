require_relative 'config/environment.rb'
require 'sinatra/activerecord/rake'
require 'pry'

namespace :db do
  task :load_config do
    require "./app/app"
  end
end

task :console do
    Pry.start
end
