require 'sinatra'
require 'sinatra/activerecord'

class HealthController < ApplicationController
  get '/health' do
    ActiveRecord::Base.connection_pool.with_connection { |con| con.active? }
    status 200
    {
      mainDatabaseConnection: 'Service online',
      cacheConnection: 'Service online'
    }.to_json
  rescue StandardError => e
    status 500
    {
      mainDatabaseConnection: 'Service offline',
      cacheConnection: 'Service offline',
      error: e.message
    }.to_json
  end
end
