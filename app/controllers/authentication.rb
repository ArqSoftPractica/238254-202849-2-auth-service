require 'jwt'
require 'json'
require 'redis'
require 'sinatra/base'

class Authentication
  AUTH_HEADERS = %w[authorization x-api-key x-access-token].freeze
  API_HEADER = 'HTTP_X_API_KEY'

  def initialize(app, roles_allowed, accept_api_key)
    @app = app
    @roles_allowed = roles_allowed
    @accept_api_key = accept_api_key
    @redis = Redis.new
  end

  def call(env)
    req = Rack::Request.new(env)
    token = nil

    AUTH_HEADERS.each do |header|
      auth_header = env["HTTP_#{header.upcase.gsub('-', '_')}"]
      if auth_header
        token = auth_header.split(' ')[1]
        break
      end
    end
    if token
      begin
        decoded = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')[0]
        if decoded['exp'] && Time.now.to_i >= decoded['exp']
          return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Not authorized' }.to_json]]
        end
        unless @roles_allowed.include?(decoded['role'])
          return [403, { 'Content-Type' => 'application/json' }, [{ error: 'Forbidden' }.to_json]]
        end

        req.env['user'] = decoded
        return @app.call(env)
      rescue StandardError => e
        # Log the error here
        return [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
      end
    end
    [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
  end
end
