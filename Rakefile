require_relative 'config/environment'
require 'sinatra/activerecord/rake'
require 'pry'

namespace :db do
  task :load_config do
    require './app'
  end
end

# add a delete_task method to the TaskManager and delete db:migrate
Rake::TaskManager.class_eval do
  def delete_task(task_name)
    @tasks.delete(task_name.to_s)
  end

  Rake.application.delete_task('db:migrate')
end

# define a new db:migrate that did the same as the old one bar the schema dump
namespace :db do
  desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x, don't run db:schema:dump at the end."

  task migrate: :environment do
    if ENV['VERSION']
      ActiveRecord::Migrator.run(:up, 'db/migrate/', ENV['VERSION'].to_i)
    else
      ActiveRecord::Migration.migrate('db/migrate/')
    end
  end
end

task :console do
  Pry.start
end
