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


end
