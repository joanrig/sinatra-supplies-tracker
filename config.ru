require './config/environment'


if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use UsersController
use ProjectsController
use SuppliesController
run ApplicationController

use Rack::MethodOverride


map('/') { run ApplicationController }
map('/users') { run UsersController }
map('/projects') { run ProjectsController }
map('/supplies') { run SuppliesController }
