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


    # params.values.first.values.each do |supply|
    #   Supply.find_or_create_by(name: supply.values.first)

    unless Supply.any? {|supply| supply.name == params[:name].capitalize}

    <th><a href="/projects/<%= @project.id %>">Edit Project Info</a></th>

    <th><a href="/supplies/assign/<%= @project.id %>">Update Supplies</a></th>
    <th><form action="/projects/<%= @project.id %>" method="post">
      <input id="hidden" type="hidden" name="_method" value="patch">
    </form><a href="/projects/<%= @project.id %>">Delete Project</a></th>
    <th><a href="/users/dashboard/<%= @project.id %>">Dashboard</a></th>


    navbar doesn't know what project is on edit show page:

    <table id="navbar">
      <tr>
        <% binding.pry %>
        <th><a href="/projects/<%= @project.id %>">Edit Project Info</a></th>
        <th><a href="/supplies/assign/<%= @project.id %>">Update Supplies</a></th>
        <th><form action="/projects/<%= @project.id %>" method="post">
          <input id="hidden" type="hidden" name="_method" value="patch">
        </form><a href="/projects/<%= @project.id %>">Delete Project</a></th>
        <th><a href="/users/dashboard/<%= @project.id %>">Dashboard</a></th>
        <th><a href="href="/users/logout">Log Out</a></th>
      </tr>
      </table>

    <br>
    <br>
    <br>
