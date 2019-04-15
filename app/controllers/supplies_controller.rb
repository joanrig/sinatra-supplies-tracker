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

    if p
      p.map do |supply_name|
        supply = Supply.find_or_create_by(name: supply_name.downcase) if supply_name != ""
        if supply
          supply.vendor = nil
          supply.website = nil
          supply.unit_type = nil
          supply.price_per_unit =  nil
          supply = {name: supply.name.downcase}
          supply.save
          @project.supplies << supply
        end
      end
    end

    @project.save
    redirect "/supplies/assign/#{@project.id}"
  end

  get '/supplies/assign/:id' do
    @user = Helpers.current_user(session)
    Helpers.must_login(session)
    @project = Project.find_by(id: params[:id])

    if @project
      @current = @project.supplies.uniq
      @all = []
      @user.projects.each do |project|
        s = project.supplies
        s.each do |supply|
          @all << supply
        end
      end
    end

    if @all && @current
      #@current are new supplies that may or may not be included in @all/ this removes overlap.
      @other = @all + @current - @current
      @other.uniq
    end

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
