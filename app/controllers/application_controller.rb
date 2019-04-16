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
    erb :'users/login'
  end

  helpers do
    def current_user
      @user||= User.find(session[:user_id]) if is_logged_in?
    end

    def is_logged_in?
      !!session[:user_id]
    end

    def must_login
      if !session[:user_id]
        redirect '/users/login'
      end
    end
  end


end
