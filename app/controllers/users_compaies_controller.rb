require 'sinatra/cross_origin'
require 'sinatra/base'
require 'json'

class UsersCompaniesController < ApplicationController
  use Authentication, %w[ADMIN INTERNAL], false

  post '/users/companies/:id' do
    user_id = env['user']['id']
    company_id = params[:id]

    if company_id && user_id
      user = User.find(user_id)
      if user.companyId.nil?
        user.update_attribute(:companyId, company_id)
        if user.errors.empty?
          status 201
          { message: 'User added to company' }.to_json
        else
          status 400
          user.errors.to_json
        end
      else
        status 400
        { message: 'User already has a company' }.to_json
      end
    else
      status 400
      { message: 'Bad request' }.to_json
    end
  end
end
