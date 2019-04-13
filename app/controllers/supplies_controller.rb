require './config/environment'
require 'sinatra/base'

class SuppliesController < ApplicationController

  get '/supplies' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supplies = Supply.all.map {|supply| supply.delete if supply.name = ""}
    @my_supplies = []
    if @user.projects.size > 1
      @user.projects.each do |project|
        @my_supplies << project.supplies if project.supplies
        @my_supplies = @my_supplies.flatten
        binding.pry
      end
    elsif user.projects.size == 1
      @my_supplies << @user.projects.first.supplies if @user.projects.first.supplies
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
    binding.pry

    @supply = Supply.find_by_id(params[:id])
    if @supply
      erb :"/supplies/show"
    else
      redirect to 'users/dashboard'
    end
  end

  get '/supplies/:id/edit' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    @supply.update(params)
    erb :'/supplies/edit'
  end

  patch '/supplies/:id' do#update supply
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
binding.
    Supply.find_by_id(params[:id]).delete
    # if Helpers.current_user(session).id != @supply.user_id
    #   #warning message - you can't delete someone else's supplies
    #   redirect to suppliess.
    # end
    redirect to '/supplies'
  end

  post '/supplies/show/project/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by(id: params[:id])

    if @project
      @current = @project.supplies.uniq
      @all = []
      @user.projects.each do |project|
        if project.supplies
          if project.supplies.size > 1
            project.supplies.uniq.each do |supply|
              @all << supply
            end
          elsif project.supplies.size == 1
            @all << project.supplies.first
          end
        end
      end
      @other = @all + @current - @current
    end
    binding.pry

    # => from text fields

    supply1 = Supply.find_or_create_by(name: params.values[1]) if params.values[1]
    supply2 = Supply.find_or_create_by(name: params.values[2]) if params.values[2]
    supply3 = Supply.find_or_create_by(name: params.values[3]) if params.values[3]

    binding.pry
    project = @project
    supplies = []
    supplies.push(supply1, supply2, supply3)
    binding.pry
    add_supplies_to_project(project, supplies)
    erb :'supplies/assign'
  end



  # get '/supplies/show/project/:id' do
  #   binding.pry
  #   @user = Helpers.current_user(session)
  #   Helpers.must_login(session)
  #   @project = Project.find_by(id: params[:id])
  #   erb :'/supplies/assign'
  # end




  ######### local helpers ############

  def add_supplies_to_project(project, supplies)
    if supplies && project
      supplies.each do |supply|
        if supply
          supply.name.capitalize
          project.supplies << supply unless project.supplies.include?(supply)
        end
      end
    end
  end



end
