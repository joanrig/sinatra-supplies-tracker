require './config/environment'
require 'sinatra/base'

class SuppliesController < ApplicationController

  get '/supplies/new' do #works
    #binding.pry
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      #flash message: please log in to create your new supply!
      redirect to '/users/login'
    else
      session[:user_id]  = @user.id
      erb :'/supplies/new'
    end
  end

  post '/supplies' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/users/login'
    else
      @found = Supply.find_by(name: params[:name].capitalize)
      binding.pry
      if @found
        #flash message - this supply already exits, redirecting you to its page
        redirect to "/supplies/#{@found.id}"
      else
        @supply = Supply.create(params)
      end

      if @supply.save
        @supply.name.capitalize
        #flash[:message] = "Successfully created supply."
        redirect to "/supplies/#{supply.id}"
      else
        #flash[:message] = "Please make sure your supply has a name."
        redirect to '/supplies/new'
      end
    end
  end


  get '/supplies/:id' do #get show page with edit button
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @supply = Supply.find_by_id(params[:id])
    if @supply
      erb :"/supplies/show"
    else
      redirect to 'users/dashboard'
    end
  end

  get '/supplies/:id/edit' do#get edit page
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @supply = Supply.find_by_id(params[:id])
    @supply.update(params)
    erb :'/supplies/edit'
  end

  patch '/:id' do#update supply
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @supply = Supply.find_by_id(params[:id])
    params.delete(:_method)
    @supply.update(params)
    @supply.save
    redirect to "/supplies/#{@supply.id}"
  end

  delete '/:id' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    Supply.find_by_id(params[:id]).delete
    # if Helpers.current_user(session).id != @supply.user_id
    #   #warning message - you can't delete someone else's supplies
    #   redirect to suppliess.
    # end
    redirect to '/supplies'
  end

  get '/supplies/assign/:id' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'#put in module
    end
    @project = Project.find_by_id(params[:id])
    @current_project_supplies = @project.supplies.uniq
    @all_my_supplies = []
    @user.projects.each do |project|
      project.supplies.uniq.each do |supply|
        @all_my_supplies << supply
        @other_supplies = @all_my_supplies - @current_project_supplies
    #binding.pry
      end
    end
    erb :'/supplies/assign'
  end

  post '/supplies/assign/:id' do
    #cannot get iteration to work, see attempts in notes
    @project = Project.find_by(name: params[:project_name])

# => create from  assign form's text fields
    supply1 = Supply.find_or_create_by(name: params[:supply1][:name]
    supply2 = Supply.find_or_create_by(name: params[:supply2][:name]
    supply3 = Supply.find_or_create_by(name: params[:supply3][:name]
    binding.pry

    project = @project
    supplies = []
    supplies.push (supply1, supply2, supply3)
    add_supplies_to_project(project, supplies)
    redirect to "projects/#{@project.id}"

  end

  ######### local helpers ############

    def add_supplies_to_project(project, supplies)
      supplies.each do |supply|
        supply.name.capitalize
        project.supplies << supply unless project.supplies.include?(supply)
      end

    end


end
