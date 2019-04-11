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
