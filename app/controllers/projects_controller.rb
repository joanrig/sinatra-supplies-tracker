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
    p = params[:name].split.map{|word| word.capitalize}.join(' ')

    @user.projects.each do |project|
      if p == project.name.split.map{|word| word.capitalize}.join(' ')
        flash[:message] = "This project already exists, redirecting you to its page."
        redirect to "/projects/#{@found.id}"
      else
        params.delete("_method")
        @new = Project.create(params)
        @new.user_id = @user.id
        binding.pry
        if @new
          flash[:message] = "Project successfully created."
          redirect to "/projects/#{@new.id}"
        end
      end
    end
  end

  get '/projects/:id' do
    binding.pry
    #get show page with edit button
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @project = Project.find_by_id(params[:id])
    if @project
      erb :"/projects/show"
    else
      redirect to "/users/dashboard/#{@user.id}"
    end
  end

  get '/projects/:id/edit' do#get edit page
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by_id(params[:id])
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

  get '/projects/:id/delete' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by_id(params[:id])

    if @project.user.id == @user.id
      @project.destroy
      flash[:message] = "Project successfully deleted."
    end
    redirect to "/users/dashboard/#{@user.id}"
  end

end
