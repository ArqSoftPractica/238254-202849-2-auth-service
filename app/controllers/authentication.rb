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
    puts "token"
    req = Rack::Request.new(env)
    token = nil

    puts "token"

    AUTH_HEADERS.each do |header|
      auth_header = req.env["HTTP_#{header.upcase.gsub('-', '_')}"]
      if auth_header
        token = auth_header.split(' ')[1]
        break
      end
    end

    puts "token: #{token}"

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
          decoded = JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')[0]
          # Expired token
          if decoded['exp'] && Time.now.to_i >= decoded['exp']
            return [401, { 'Content-Type' => 'application/json' }, [{ error: 'Not authorized' }.to_json]]
          end

          puts "decoded: #{decoded}"
          puts @roles_allowed
        if @roles_allowed.include?(decoded['role'])
          req.env['user'] = decoded
          return @app.call(env)
        else
          return [403, { 'Content-Type' => 'application/json' }, [{ error: 'Forbidden' }.to_json]]
        end
      rescue => error
        # Log the error here
        return [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
      end
    end
    return [401, { 'Content-Type' => 'application/json' }, [{ message: 'Unauthorized' }.to_json]]
  end

  def validate_invitation_token(token)
    begin
      # Replace the following line with the function to get the invitation token information
      return get_invitation_token_information(token)
    rescue => error
      return false
    end
  end

end
