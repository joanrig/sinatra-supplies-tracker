require './config/environment'

class ApplicationController < Sinatra::Base
  #use Rack::Flash

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
    if Helpers.is_logged_in?(session)
      erb :'/users/dashboard'
    else
      erb :'/users/signup'
    end
  end

  post '/users/login' do
    #validators in user class already check for presence of name, email and password
    if params[:email].match(URI::MailTo::EMAIL_REGEXP).present?
      @user = User.create(params)
    end

    if @user
      #flash[:message] = "Account successfully created"
      redirect to '/users/dashboard'
    else
      #flash[:error] = "Something went wrong. Please try again."
      redirect to '/users/signup'
    end
  end

  get '/users/dashboard' do
    erb :'/users/dashboard'
  end



end
