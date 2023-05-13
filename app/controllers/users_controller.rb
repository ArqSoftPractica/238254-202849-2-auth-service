class UsersController < ApplicationController
  post '/users' do
    if user_params&.token.present?
      token_hash = JWT.decode payload, ENV['JWT_SECRET'], true, { algorithm: 'HS256' }
      invitation = Invitation.find_by(id: token_hash['id'], acceptedAt: nil)
      if invitation.present?
        user_params['role'] = token_hash['role']
        user_params['companyId'] = token_hash['companyId']
      end
    end

    @user = User.new user_params
    if @user.save
      invitation.update! acceptedAt: Time.now if invitation.present?

      status 201
      @user.to_json
    else
      status 400
      @user.errors.to_json
    end
  end

  private

  def user_params
    @user_params ||= Hashie::Mash.new(params).permit(:name, :email, :password, :role, :token)
  end
end
