require './config/environment'
# require_relative 'app/controllers/projects_controller'
# require_relative 'app/controllers/supplies_controller'


if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end


run ApplicationController
use UsersController
use ProjectsController
use SuppliesController

use Rack::MethodOverride


map('/') { run ApplicationController }
map('/users') { run UsersController }
map('/projects') { run ProjectsController }
map('/supplies') { run SuppliesController }
