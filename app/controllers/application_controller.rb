require './config/environment'
require 'sinatra/base'
#require 'sinatra-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'password_security'
    register Sinatra::Flash
  end

  get "/" do
    binding.pry
    flash[:message] = "Hooray, Flash is working!"
    erb :'users/welcome'
  end

  get "/users" do
    #flash[:notice] = "Hooray, Flash is working!"
    erb :'users/welcome'
  end

  get '/users/signup' do
    # if Helpers.is_logged_in?(session)
    #   erb :'/users/dashboard'
    # else
      erb :'/users/signup'
    # end
  end

  post '/users/signup' do #create user and log them in
    if params[:email].match(URI::MailTo::EMAIL_REGEXP).present?
      @user = User.create(params)
      session[:user_id] = @user.id
      @user.save
      binding.pry
    end

    if @user #flash[:message] = "Account successfully created"
      erb :'/users/dashboard'
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
    user = User.find_by(name: params[:name], email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      #binding.pry
      redirect to '/users/dashboard'
    else
      #flash[:login_error] = "Incorrect login. Please try again."
      redirect to '/users/error'
    end
  end

  get '/users/dashboard' do
    if !Helpers.is_logged_in?(session)
     redirect to '/login'
   end
   @projects = Project.all
   @user = Helpers.current_user(session)
    erb :'/users/dashboard'
  end

end
