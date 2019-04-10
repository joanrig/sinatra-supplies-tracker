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

  get "/users" do
    #flash[:notice] = "Hooray, Flash is working!"
    erb :'users/welcome'
  end

  get '/users/signup' do
    if Helpers.is_logged_in?(session)
      erb :'/users/dashboard'
    else
      erb :'/users/signup'
    end
  end


    post '/users/signup' do
      if params[:email].match(URI::MailTo::EMAIL_REGEXP).present?
      user = User.new(:name => params[:name], :password => params[:password])
      if user.save
        redirect "/users/login"
      else
        redirect "/users/signup"
       #flash[:error] = "Something went wrong. Please try again."
      end
    end


    if @user
      #flash[:message] = "Account successfully created"
      redirect to '/users/dashboard'
    else
      #flash[:error] = "Something went wrong. Please try again."
      redirect to '/users/signup'
    end
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
      redirect to '/users/login'
    end
  end

  get '/users/dashboard' do
    erb :'/users/dashboard'
  end



end
