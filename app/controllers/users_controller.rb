require './config/environment'
require 'sinatra/base'

class UsersController < ApplicationController

  get "/" do
    erb :'users/welcome'
  end

  get "/users" do
    erb :'users/welcome'
  end

  get '/users/signup' do
    erb :'/users/signup'
  end

  post '/users/signup' do #create user and log them in
    @user = User.create(params)
    session[:user_id] = @user.id
    if @user #flash[:message] = "Account successfully created"
      erb :'/users/dashboard'
    else #flash[:error] = "Something went wrong. Please try again."
      redirect to '/users/login'
    end
  end

  get '/users/error' do
    erb :'users/error'
  end

  get '/users/login' do
    erb :'/users/login'
  end

  post '/users/login' do
    @user = User.find_by(name: params[:name], email: params[:email])
    if @user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to "/users/dashboard/#{@user.id}"
    else
      # flash[:login_error] = "Incorrect login. Please try again."
      redirect to '/users/error'
    end
  end

  get '/users/dashboard' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
     redirect to '/login'
    else
      @projects = Project.where(:user_id == @user.id)
      binding.pry
      erb :'/users/dashboard'
    end
  end

  get '/users/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
      redirect to '/users/login'
    else
      redirect to '/'
    end
  end


end
