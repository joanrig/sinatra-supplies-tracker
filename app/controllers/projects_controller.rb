require './config/environment'

class ProjectsController < ApplicationController


  get '/projects/new' do #works
    @user = current_user
    must_login
    session[:user_id]  = @user.id
    erb :'/projects/new'
  end

  post '/projects' do
    @user = current_user
    must_login
    #params =>{xx:"hello"}
    p = params[:name].split.map{|word| word.capitalize}.join(' ')

    if !@user.projects.empty? #if user already has projs
      @user.projects.each do |project|
        if p == project.name.split.map{|word| word.capitalize}.join(' ')
          flash[:message] = "This project already exists, redirecting you to its page."
          redirect to "/projects/#{@found.id}"
        else
          binding.pry
          @new = Project.create(params)
        end
      end
    else
      binding.pry
      @new = Project.create(params)
    end

   #@user.projects.build(params)

    #@new.user_id = @user.id
    @user.projects << @new

    if @new
      flash[:message] = "Project successfully created."
      redirect to "/projects/#{@new.id}"
    end

  end

  get '/projects/:id' do
    #get show page with edit button
    @user = current_user
    must_login

    @project = Project.find_by_id(params[:id])
    if @project
      erb :"/projects/show"
    else
      redirect to "/users/dashboard/#{@user.id}"
    end
  end

  get '/projects/:id/edit' do#get edit page
    @user = current_user
    must_login
    @project = Project.find_by_id(params[:id])
    erb :'/projects/edit'
  end

  patch '/:id' do#update project
    @user = current_user
    must_login
    @project = Project.find_by_id(params[:id])

    params.delete(:_method)
    params.delete_if {|key, value| value == "" }
    @project.update(params)
    @project.save
    redirect to "/projects/#{@project.id}"#{show edited proj}
  end

  get '/projects/:id/delete' do
    @user = current_user
    must_login
    @project = Project.find_by_id(params[:id])

    if @project.user.id == @user.id
      @project.destroy
      flash[:message] = "Project successfully deleted."
    end
    redirect to "/users/dashboard/#{@user.id}"
  end

end
