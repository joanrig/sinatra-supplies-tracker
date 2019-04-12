class Helpers < ActiveRecord::Base
  def self.current_user(session)
    @user||= User.find(session[:user_id])
  end

  def self.is_logged_in?(session)
    !!session[:user_id]
  end

  def self.must_login(session)
    if !session[:user_id]
      redirect to '/users/login'
    end
  end

end
