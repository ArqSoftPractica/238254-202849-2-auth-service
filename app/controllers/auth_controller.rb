class AuthController < ApplicationController
  post '/login' do
    @user = User.find_by email: login_params[:email]
    if @user&.authenticate(login_params[:password])
      payload = {
        id: @user.id,
        email: @user.email,
        role: @user.role,
        companyId: @user.companyId
      }
      expires_in = Time.now.to_i + (ENV['JWT_EXPIRATION'].to_i || 4 * 3600)
      status 200
      JWT.encode payload, ENV['JWT_SECRET'], 'HS256', { exp: expires_in }
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
