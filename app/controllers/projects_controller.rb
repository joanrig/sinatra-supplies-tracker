require './config/environment'

class ProjectsController < ApplicationController


  get '/projects/new' do #works
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    erb :'/projects/new'
  end

  post '/projects/new' do  #works
    project = Project.create(params)

    #binding.pry
    if project
      @project = Project.find_by(name: "#{project.name}")
      redirect to :"/projects/#{project.id}"
    else
      redirect to "/projects/error"
    end
  end

  get '/projects/edit' do
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    # @user = User.find(session[:user_id])
    # @user_id = session[:user_id]
    # binding.pry
    # @project = Project.find(params[:id])
    # binding.pry
    erb :'/projects/edit'
  end

  get '/projects/:id' do #works
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end

    @project = Project.find_by_id(params[:id])
    if @project
      erb :"/projects/#{@project.id}"
    else
      redirect to :'users/dashboard'
    end
  end

end
