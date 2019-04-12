require './config/environment'
require 'sinatra/base'

class SuppliesController < ApplicationController

  get '/supplies' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supplies = Supply.all
    @my_supplies = []
    @user.projects.each do |project|
      @my_supplies << @project.supplies
    end
    erb :'/supplies/index'
  end

  get '/supplies/new' do #works
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    session[:user_id]  = @user.id
    erb :'/supplies/new'
  end

  post '/supplies' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @found = Supply.find_by(name: params[:name].capitalize)
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


  get '/supplies/:id' do #get show page with edit button
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    if @supply
      erb :"/supplies/show"
    else
      redirect to 'users/dashboard'
    end
  end

  get '/supplies/:id/edit' do#get edit page
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    @supply.update(params)
    erb :'/supplies/edit'
  end

  patch '/:id' do#update supply
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    params.delete(:_method)
    @supply.update(params)
    @supply.save
    redirect to "/supplies/#{@supply.id}"
  end

  delete '/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    Supply.find_by_id(params[:id]).delete
    # if Helpers.current_user(session).id != @supply.user_id
    #   #warning message - you can't delete someone else's supplies
    #   redirect to suppliess.
    # end
    redirect to '/supplies'
  end

  get '/supplies/assign/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

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
    Helpers.must_login(session)
    @project = Project.find_by(name: params[:project_name])

# => create from  assign form's text fields/ see pirate ships lab
    supply1 = Supply.find_or_create_by(name: params[:supply1][:name])
    supply2 = Supply.find_or_create_by(name: params[:supply2][:name])
    supply3 = Supply.find_or_create_by(name: params[:supply3][:name])

    project = @project
    supplies = []
    supplies.push(supply1, supply2, supply3)
    add_supplies_to_project(project, supplies)
    redirect to "supplies/assign/#{@project.id}"
  end

  ######### local helpers ############

    def add_supplies_to_project(project, supplies)
      binding.pry
      supplies.each do |supply|
        if supply.name
          supply.name.capitalize
          project.supplies << supply unless project.supplies.include?(supply)
        end
      end
    end



end
