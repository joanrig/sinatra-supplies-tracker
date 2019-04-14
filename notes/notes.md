to ask:


flash code for layout.erb
<% flash.keys.each do |type| %>
<div data-alert class="flash <%= type %> alert-box radius">
  <%= flash[type] %>
  <a href="#" class="close">&times;</a>
</div>
<% end %>


    def logged_in?
      !!current_user
    end

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end




    <a href="/projects/<%= @project.id %>">Delete Project</a></th>
    <th><a href="/users/dashboard/<%= @project.id %>">Dashboard</a></th>

    # get '/supplies/assign/project/:id' do
    #   binding.pry
    #   @user = Helpers.current_user(session)
    #   Helpers.must_login(session)
    #   @project = Project.find_by(id: params[:id])
    #   erb :'/supplies/assign'
    # end

    navbar doesn't know what project is on edit show page:




    post '/supplies' do
      @user = Helpers.current_user(session)
      Helpers.must_login(session)

      @found = Supply.find_by(name: params[:name].downcase)
      binding.pry
      if @found
        #flash message - this supply already exits, redirecting you to its page
        redirect to "/supplies/#{@found.id}"
      else
        params.delete("_method")
        params[:name].downcase
        @supply = Supply.create(params)
      end

      if @supply.save
        #flash[:message] = "Successfully created supply."
        erb :'/supplies/show'
      else
        #flash[:message] = "Please make sure your supply has a name."
        redirect to '/supplies/new'
      end
    end
