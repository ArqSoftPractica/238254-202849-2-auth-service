require_relative 'config/environment'
require_relative 'app'
require 'dotenv/load'
require 'dotenv'

Dotenv.load
use Rack::MethodOverride
use App
use UsersController
use AuthController
use HealthController
use UsersCompaniesController

run ApplicationController
