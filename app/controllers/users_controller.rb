require './config/environment'
require 'sinatra/base'

class UsersController < ApplicationController

  get "/users" do
    erb :'users/login'
  end

  get '/users/signup' do
    erb :'/users/signup'
  end

  post '/users/signup' do
    if User.find_by(email: params[:email])
      #flash[:message] = "This email address already has an account. Please log in."
      redirect to "/users/login"
    else
      @user = User.new(params)
      if @user.save #flash[:message] = "Account successfully created"
        session[:user_id] = @user.id
        erb :'/users/dashboard'
      else
        #flash[:error] = "Something went wrong. Please try again."
        redirect to '/users/login'
      end
    end
  end

  get '/users/error' do
    erb :'users/error'
  end

  get '/users/login' do
    erb :'/users/login'
  end

  post '/users/login' do
    session.clear
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      @projects = @user.projects
      erb :"/users/dashboard"
    else
      # flash[:login_error] = "Incorrect login. Please try again."
      redirect to '/users/error'
    end
  end

  get '/users/logout' do
    if Helpers.is_logged_in?(session)
      session.clear
      redirect to '/'
    end
  end

  get '/users/dashboard/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @projects = @user.projects
    erb :'/users/dashboard'
  end


end
