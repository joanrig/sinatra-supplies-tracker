require './config/environment'
require 'sinatra/base'

class ProjectsController < ApplicationController

  get '/users/dashboard'
    @projects = Project.all
  end


end
