class AuthController < ApplicationController
  post '/login' do
    @user = User.find_by email: login_params[:email]
    if @user&.authenticate(login_params[:password])
      expires_in = Time.now.to_i + (ENV['JWT_EXPIRATION'].to_i || 4 * 3600)
      payload = {
        id: @user.id,
        email: @user.email,
        name: @user.name,
        role: @user.role,
        companyId: @user.companyId
        exp: expires_in
      }
      status 200
      token = JWT.encode payload, ENV['JWT_SECRET'], 'HS256', { exp: expires_in }
      token.to_json
    else
      status 401
      'Unauthorized'
    end
  end

  private

  def login_params
    @body_request ||= JSON.parse(request.body.read).transform_keys(&:to_sym)
    @login_params ||= @body_request.slice(:email, :password)
  end
end
