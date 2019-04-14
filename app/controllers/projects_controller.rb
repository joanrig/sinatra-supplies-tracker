require './config/environment'

class ProjectsController < ApplicationController


  get '/projects/new' do #works
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    session[:user_id]  = @user.id
    erb :'/projects/new'
  end

  post '/projects' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @found = Project.find_by(name: params[:name].downcase)
    if @found
      #flash message - this project already exits, redirecting you to its page
      redirect to "/projects/#{@found.id}"
    else
      params.delete("_method")
      params[:name].downcase
      @project = Project.create(params)
    end

    @project.user_id = @user.id
    if @project.save
      @user.projects << @project
      #flash[:message] = "Successfully created project."
      redirect to "/projects/#{@project.id}"
    else
      #flash[:message] = "Please make sure your project has a name."
      redirect to '/projects/new'
    end
  end


  get '/projects/:id' do #get show page with edit button
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @project = Project.find_by_id(params[:id])
    if @project
      erb :"/projects/show"
    else
      redirect to 'users/dashboard'
    end
  end

  get '/projects/:id/edit' do#get edit page
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @project = Project.find_by_id(params[:id])
    @project.update(params)
    @project.save
    erb :'/projects/edit'
  end


  patch '/:id' do#update project
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @project = Project.find_by_id(params[:id])
    params.delete(:_method)
    params.delete_if {|key, value| value == "" }
    @project.update(params)
    @project.save
    redirect to "/projects/#{@project.id}"#{show edited proj}
  end

  post 'projects/:id/delete' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    
    Project.find(params[:id]).delete
    redirect to "/users/dashboard/#{@user.id}"
  end

end
