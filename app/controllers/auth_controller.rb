class AuthController < ApplicationController
  post '/login' do
    @user = User.find_by email: login_params[:email]
    if @user && @user.authenticate(login_params[:password])
      payload = {
        id: @user.id,
        email: @user.email,
        role: @user.role,
        companyId: @user.companyId
      }
      expiresIn = Time.now.to_i + (ENV['JWT_EXPIRATION'] || 4 * 3600)
      status 200
      JWT.encode payload, ENV['JWT_SECRET'], 'HS256', { exp: expiresIn }
    else
      status 401
      'Unauthorized'
    end
  end

  private

  def login_params
    @login_params ||= Hashie::Mash.new(params).permit(:email, :password)
  end
end
