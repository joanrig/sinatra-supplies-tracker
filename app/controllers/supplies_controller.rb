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
      supply = Supply.create(params)
      #supply.user_id = @user.id
      if supply.save
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
    #binding.pry
    if @supply
      erb :"/supplies/show"
    else
      redirect to '/users/dashboard'
    end
  end

  get '/suppliess/:id/edit' do#get edit page
    #binding.pry
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
    redirect to "/supplies/#{@supply.id}"#{show edited proj}
  end

  delete '/:id' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @supply = Supply.find_by_id(params[:id])
    # if Helpers.current_user(session).id != @supply.user_id
    #   #warning message - you can't delete someone else's supplies
    #   redirect to suppliess.
    # end
    @supply.delete
    redirect to '/supplies'
  end

  get '/supplies/assign/:id' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @project = Project.find_by_id(params[:id])
    erb :'/supplies/assign'
  end

  post '/supplies/assign/:id' do
    params.delete(:id)
    params.values.each do |supply|
      Supply.find_or_create_by(name: supply.values)
      binding.pry
    end
  end


end
