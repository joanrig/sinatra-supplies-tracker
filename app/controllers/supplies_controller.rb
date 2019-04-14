require './config/environment'
require 'sinatra/base'

class SuppliesController < ApplicationController

  # get '/supplies' do
  #   @user = Helpers.current_user(session)
  #   Helpers.must_login(session)
  #
  #   @supplies = Supply.all.map {|supply| supply.delete if supply.name = ""}
  #   @my_supplies = []
  #   if @user.projects.size > 1
  #     @user.projects.each do |project|
  #       @my_supplies << project.supplies if project.supplies
  #       @my_supplies = @my_supplies.flatten
  #       binding.pry
  #     end
  #   elsif user.projects.size == 1
  #     @my_supplies << @user.projects.first.supplies if @user.projects.first.supplies
  #   end
  #   erb :'/supplies/index'
  # end

  get '/supplies/new' do #works
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    session[:user_id]  = @user.id
    erb :'/supplies/new'
  end

  post '/supplies' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @found = Supply.find_by(name: params[:name].downcase)
    binding.pry
    if @found
      #flash message - this supply already exits, redirecting you to its page
      redirect to "/supplies/#{@found.id}"
    else
      params.delete("_method")
      binding.pry
      @supply = Supply.create(params)
      binding.pry
    end

    if @supply.save
      #flash[:message] = "Successfully created supply."
      erb :'/supplies/show'
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
      user = @user
      Helpers.all_supplies(user)
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

  patch '/:id' do#update supply
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @supply = Supply.find_by_id(params[:id])
    params.delete("_method")
    params.delete_if {|key, value| value == "" }
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

  post '/supplies/assign/project/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by(id: params[:id])
    user = @user

    if @project
      @current = @project.supplies.uniq
      @all = []
      @user.projects.each do |project|
        s = project.supplies
        s.each do |supply|
          @all << supply
        end
      end
    end

    if @other && @all && @current
      binding.pry
      @other = @all + @current - @current
    end

    # => from text fields
    new = params.values[1..3]
    new.each do |value|
      if value != ""
        @project.supplies << Supply.find_or_create_by(name: value.downcase)
      end
    end
    erb :'supplies/assign'
  end


end
