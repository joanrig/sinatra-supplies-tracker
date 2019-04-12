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


supplies find or create by name from hash:
[22] pry(#<SuppliesController>)> params.values.each do |supply|
[22] pry(#<SuppliesController>)*   Supply.find_or_create_by(name: supply.values)
[22] pry(#<SuppliesController>)* end  
D, [2019-04-12T09:27:18.480133 #18384] DEBUG -- :   Supply Load (0.2ms)  SELECT  "supplies".* FROM "supplies" WHERE "supplies"."name" = 'police box' LIMIT 1
D, [2019-04-12T09:27:18.481089 #18384] DEBUG -- :   Supply Load (0.1ms)  SELECT  "supplies".* FROM "supplies" WHERE "supplies"."name" = 'helmet' LIMIT 1
D, [2019-04-12T09:27:18.481745 #18384] DEBUG -- :   Supply Load (0.1ms)  SELECT  "supplies".* FROM "supplies" WHERE "supplies"."name" = 'space suit' LIMIT 1
=> [{"name"=>"police box"}, {"name"=>"helmet"}, {"name"=>"space suit"}]
[23] pry(#<SuppliesController>)> params
=> {"supply1"=>{"name"=>"police box"}, "supply2"=>{"name"=>"helmet"}, "supply3"=>{"name"=>"space suit"}}
[24] pry(#<SuppliesController>)> 
