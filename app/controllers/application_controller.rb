require './config/environment'

class ApplicationController < Sinatra::Base
  enable :sessions
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, 'password_security'
  end

  get "/" do
    erb :'users/welcome'
  end

  get '/users/signup' do
    if Helpers.is_logged_in?
      erb :'/users/dashboard'
    else
      erb :'/users/signup'
    end
  end

  post '/users/login' do
    #validators in user class already check for presence of name, username, email
    if @email.match(URI::MailTo::EMAIL_REGEXP).present?
      @user = User.create(params)
    end

    if @user
      flash[:message] = "Account successfully created"
      erb :'/users/dashboard'
    else
      flash[:error] = "Something went wrong. Please try again."
      erb :'/users/signup'
    end
  end

  get '/users/dashboard' do 
    erb :'/users/dashboard'
  end



end
