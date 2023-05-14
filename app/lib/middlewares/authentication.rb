require 'jwt'
require 'json'
require 'redis'
require 'sinatra/base'

class Authentication
  AUTH_HEADERS = %w[authorization x-api-key x-access-token].freeze
  API_HEADER = 'HTTP_X_API_KEY'


  def initialize(app, roles_allowed: [], accept_api_key: false)
    @app = app
    @roles_allowed = roles_allowed
    @accept_api_key = accept_api_key
    @redis = Redis.new
  end

  def call(env)
    req = Rack::Request.new(env)
    api_key = req.env[]
    token = nil

    AUTH_HEADERS.each do |header|
      auth_header = req.env["HTTP_#{header.upcase.gsub('-', '_')}"]
      if auth_header
        token = auth_header.split(' ')[1]
        break
      end
    end

    if token.nil?
      token = req.params['token'] || req.GET['token'] || req.POST['token']
      if token
        decoded_token = validate_invitation_token(token)
        if decoded_token
          req.env['invitation_token'] = decoded_token
        end
        return @app.call(env)
      elsif !accept_api_key || (accept_api_key && api_key.nil?)
        return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Not authorized' }.to_json]]
      end
    end

    if token
      begin
        cached = look_cache(token)
        if cached
          decoded = JSON.parse(cached)
        else
          decoded = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')[0]

          # Expired token
          if decoded['exp'] && Time.now.to_i >= decoded['exp']
            return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Not authorized' }.to_json]]
          end
        end

        if roles_allowed.include?(decoded['role'])
          req.env['user'] = decoded
          store_cache(token, decoded)
          return @app.call(env)
        else
          return [403, { 'Content-Type' => 'application/json' }, [{ error: 'Forbidden' }.to_json]]
        end
      rescue => error
        # Log the error here
        return [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
      end
    else
      company_id = look_cache(api_key).to_i
      if company_id.zero?
        begin
          # Replace the following line with the function to get the company_id by the API key
          company_id = get_company_id_by_api_key(api_key)
          store_unlimited_cache(api_key, company_id.to_s)
        rescue => e
          return [403, { 'Content-Type' => 'application/json' }, [{ error: 'Forbidden' }.to_json]]
        end
      end
      req.env['company_id'] = company_id
      return @app.call(env)
    end
  end

  def validate_invitation_token(token)
    begin
      # Replace the following line with the function to get the invitation token information
      return get_invitation_token_information(token)
    rescue => error
      return false
    end
  end

  def look_cache(token)
    @redis.get(token)
  end

  def store_cache(token, user)
    time_remaining = user['exp'] * 1000 - Time.now.to_i
    @redis.set(token, user.to_json, ex: time_remaining)
  end
end
