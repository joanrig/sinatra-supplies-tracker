class SuppliesController < ApplicationController

  # get '/supplies/new' do
  #   @user = Helpers.current_user(session)
  #   Helpers.must_login(session)
  #   session[:user_id]  = @user.id
  #   erb :'/supplies/new'
  # end

  patch '/assign/:id/edit' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by(id: params[:id])
    p = params[:user][:project_ids][:supplies]
    p.delete("")

    p.map do |new_supply_name|
      @found = @user.supplies.where(name: "#{new_supply_name}")
      if @found.empty?
        new_supply = Supply.new(name: new_supply_name.downcase)
        binding.pry
        new_supply.user_id = @user.id
        new_supply.save
        @project.supplies << new_supply #succesfully creates item
        flash[:message] = "Successfully created new supply and added it to this project."
      else
        @project.supplies << @found
        binding.pry
        @project.save
      end
    end

    @project.save
    redirect "/supplies/assign/#{@project.id}"
  end

  get '/supplies/assign/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by(id: params[:id])
    @other = (@user.supplies + @project.supplies - @project.supplies).uniq
    binding.pry
    erb :'/supplies/assign'
  end

  get '/supplies/:id' do #get show page with edit button
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    if @supply
      erb :"/supplies/show"
    else
      redirect to "/users/dashboard/#{@user.id}"
    end
  end

  get '/supplies/:id/edit' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    @supply.update(params)
    erb :'/supplies/edit'
  end

  patch '/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)

    @supply = Supply.find_by_id(params[:id])
    params.delete("_method")
    params.delete_if {|key, value| value == "" }
    @supply.update(params)
    @supply.save
    redirect to "/supplies/#{@supply.id}"
  end

  get '/supplies/:id/delete' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @supply = Supply.find_by_id(params[:id])

    if @user.projects.any? {|project| project.supplies.include?(@supply)}
      @supply.destroy
      flash[:message] = "Supply was successfully deleted."
    end
    redirect to "/users/dashboard/#{@user.id}"
  end


end
