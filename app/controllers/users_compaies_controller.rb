require 'sinatra/cross_origin'


class UsersCompaniesController < ApplicationController

  use ::Authentication, ['ADMIN'], false



  post '/users/companies/:id' do
    req = Rack::Request.new(env)
    company_id = params[:id]
    user_id = req.env['user'].id

    if company_id && user_id 
      user = User.find(user_id)
      if user.company_id.nil?
        user.update(companyId: company_id)
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
      {message: 'Bad request'}.to_json
    end
  end


end
