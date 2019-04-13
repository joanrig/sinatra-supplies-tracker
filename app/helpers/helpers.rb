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

  def self.all_supplies(user)
    @user = user
    @all = []
    @user.projects.each do |project|
      if project.supplies
        if project.supplies.size > 1
          project.supplies.uniq.each do |supply|
            @all << supply
          end
        elsif project.supplies.size == 1
          @all << project.supplies.first
        end
      end
      @all
    end
  end







end
