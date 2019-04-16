# class Helpers < ApplicationController
#   def self.current_user(session)
#     @user||= User.find(session[:user_id]) if self.is_logged_in?(session)
#   end
#
#   def self.is_logged_in?(session)
#     !!session[:user_id]
#   end
#
#   def self.must_login(session)
#     if !session[:user_id]
#       redirect '/users/login'
#     end
#   end
#
#
# end
