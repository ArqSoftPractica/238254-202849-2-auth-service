class App < Sinatra::Base
  set :root, File.dirname(__FILE__)
  require File.join(root, '/config/initializers/autoloader')
end
