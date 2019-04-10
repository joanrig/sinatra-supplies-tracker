require './config/environment'
require 'sinatra/base'
#require 'sinatra-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, 'password_security'
    #register Sinatra::Flash
  end

  get "/" do
    erb :'users/welcome'
  end

  get "/users" do
    #flash[:notice] = "Hooray, Flash is working!"
    erb :'users/welcome'
  end

  get '/users/signup' do #logged in user can't view login page
    if Helpers.is_logged_in?(session)
      erb :'/users/dashboard'
    else
      erb :'/users/signup'
    end
  end

  post '/users/signup' do #create user and log them in
    if params[:name] && params[:email] && params[:password]
      if params[:email].match(URI::MailTo::EMAIL_REGEXP).present?
        @user = User.create
        @user.name = params[:name]
        @user.email = params[:email]
        @user.password = params[:password]
      end
    end

    if @user #flash[:message] = "Account successfully created"
      redirect to '/users/dashboard'
    else #flash[:error] = "Something went wrong. Please try again."
      redirect to '/users/error'
    end
  end

  get '/users/error' do
    erb :'users/error'
  end

  get '/users/login' do
    erb :'/users/login'
  end

  post '/users/login' do
    user = User.find_by(:email => params["email"])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/users/dashboard'
    else
      #flash[:login_error] = "Incorrect login. Please try again."
      redirect to '/users/error'
    end
  end

  get '/users/dashboard' do
    erb :'/users/dashboard'
  end

end
