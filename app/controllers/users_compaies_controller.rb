require 'sinatra/cross_origin'
require 'sinatra/base'
require 'json'


class UsersCompaniesController < ApplicationController
  use Authentication, ['ADMIN'], false
  
  post '/users/companies/:id' do
    user_id = env['user']['id']
    company_id = params[:id]
    puts "user_id: #{user_id}"
    puts "company_id: #{company_id}"

    if company_id && user_id 
      user = User.find(user_id)
      if user.companyId.nil?
        puts "user: #{user}"
        user.update_attribute(:companyId, company_id)
        puts "updated user: #{user}"
        puts user.errors.empty?
        if user.errors.empty?
          status 201
          { message: 'User added to company' }.to_json
        else
          status 400
          user.errors.to_json
        end
      else
        puts "user already has a company"
        status 400
        { message: 'User already has a company' }.to_json
      end
    else
      status 400
      {message: 'Bad request'}.to_json
    end
  end


end
