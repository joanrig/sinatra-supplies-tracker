require './config/environment'

class ProjectsController < ApplicationController


  get '/projects/new' do #works
    binding.pry
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)

      #flash message: please log in to create your new project!
      #binding.pry
      redirect to '/users/login'
    else
      #binding.pry
      session[:user_id]  = @user.id
      erb :'/projects/new'
    end
  end

  post '/projects' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/users/login'
    else
      project = Project.create(params)
      project.user_id = @user.id
      if project.save
        @user.projects << project
        #flash[:message] = "Successfully created project."
        redirect to "/projects/#{project.id}"
      else
        #flash[:message] = "Please make sure your project has a name."
        redirect to '/projects/new'
      end
    end
  end


  get '/projects/:id' do #get show page with edit button
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @project = Project.find_by_id(params[:id])
    #binding.pry
    if @project
      erb :"/projects/show"
    else
      redirect to '/users/dashboard'
    end
  end

  get '/projects/:id/edit' do#get edit page
    #binding.pry
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @project = Project.find_by_id(params[:id])
    @project.update(params)
    erb :'/projects/edit'
  end

  patch '/:id' do#update project
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @project = Project.find_by_id(params[:id])
    params.delete(:_method)
    @project.update(params)
    @project.save
    redirect to "/projects/#{@project.id}"#{show edited proj}
  end

  delete '/:id' do
    @user = Helpers.current_user(session)
    if !Helpers.is_logged_in?(session)
      redirect to '/login'
    end
    @project = Project.find_by_id(params[:id])
    # if Helpers.current_user(session).id != @project.user_id
    #   #warning message - you can't delete someone else's proj
    #   redirect to projects.
    # end
    @project.delete
    redirect to '/projects'
  end

end
