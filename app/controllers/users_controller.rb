require 'sinatra/cross_origin'

class UsersController < ApplicationController
  post '/users' do
    if user_params[:token].present? && user_params[:token] != ''
      token_hash = (JWT.decode user_params[:token], ENV['JWT_SECRET'], true, { algorithm: 'HS256' })[0]
      if token_hash.present?
        user_params['role'] = token_hash['role']
        user_params['companyId'] = token_hash['companyId']
      end
    end

    user_params.delete(:token)

    @user = User.new user_params
    if @user.save
      status 201
      result = %i[id email name role companyId created_at updated_at].each_with_object({}) do |k, h|
        h[k] = @user[k]
      end
      result.to_json
    else
      status 400
      @user.errors.to_json
    end
  end

  get '/users' do
    users = if get_user_params[:users_ids].present?
              User.where(id: get_user_params[:users_ids])
            elsif get_user_params[:companyId].present?
              User.where(companyId: get_user_params[:companyId])
            else
              User.all
            end
    users
      .select(:id, :email, :name, :role, :companyId, :created_at, :updated_at)
      .to_json
  end

  private

  def user_params
    @body_request ||= JSON.parse(request.body.read || '').transform_keys(&:to_sym)
    @user_params ||= %i[name email password role token].each_with_object({}) do |k, h|
      h[k] = @body_request[k]
    end
  end

  def get_user_params
    @get_user_params ||= %i[users_ids companyId].each_with_object({}) do |k, h|
      h[k] = params[k] || nil
    end
  end
end
