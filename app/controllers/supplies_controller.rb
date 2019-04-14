require './config/environment'
require 'sinatra/base'

class SuppliesController < ApplicationController


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

    if @found
      #flash message - this supply already exits, redirecting you to its page
      redirect to "/supplies/#{@found.id}"
    else
      params.delete("_method")
      params[:name].downcase
      @supply = Supply.create(params)
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

    if @all && @current
      @other = @all + @current - @current
      @other.uniq
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

  post '/supplies/add/project/:id' do
    Hello World
    binding.pry
    erb :'supplies/assign'
  end


end
