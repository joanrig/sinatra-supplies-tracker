require_relative "../spec_helper"
require 'sinatra/base'


def app
  ApplicationController
end

describe ApplicationController do
  it 'loads the welcome page' do
    get '/users'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome to your project Supply Tracker!")
  end
end

describe "Signup Page" do
  it 'loads the signup page' do
    get '/users/signup'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Please sign up to use our free service")
    expect(last_response.body).to include("</form>")
  end

  it 'reloads signup page if user tries to sign up without a name' do
    params = {
      :name => "",
      :email => "banana@aol.com",
      :password => "howgoesit"
    }
    post '/users/signup', params
    expect(page).to have_current_path('/users/login')
  end

  it 'does not let a user sign up without an email' do
    visit '/users/signup'
    fill_in "name", :with => "Garfield"
    fill_in "email", :with => ""
    fill_in ":password", :with => "lasagna"
    click_button "submit"
    expect(last_request.path).to eq('/users/signup')
  end


  it 'does not let a user sign up without a password' do
    visit '/users/signup'
    fill_in "name", :with => "Garfield"
    fill_in "email", :with => "garfield@jon.com"
    fill_in ":password", :with => ""
    click_button "submit"
    expect(last_request.path).to eq('/users/signup')
  end

  it 'does not let a user sign up with an invalid email' do
    visit '/users/signup'
    fill_in "name", :with => "Garfield"
    fill_in "email", :with => "garfield"
    fill_in ":password", :with => "lasagna"
    click_button "submit"
    expect(last_request.path).to eq('/users/signup')
  end

  it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
    visit '/users/signup'
    fill_in "name", :with => "Garfield"
    fill_in "email", :with => "garfield@jon.com"
    fill_in ":password", :with => "lasagna"
    click_button "submit"
    expect(last_request.path).to eq('/users/dashboard')
  end
end


describe "login" do
  it 'loads the login page' do
    get '/users/login'
    expect(last_response.status).to eq(200)
  end

  it 'loads the dashboard after successful login' do
    user1 = User.create(:name => "Sam", :email => "sam@aol.com", :password => "galaxy")
    params1 = {
      :name => "Sam",
      :email => "sam@aol.com",
      :password => "galaxy"
    }

    user2 = User.create(:name => "Wonder Woman", :email => "whoops", :password => "")
    params2 = {
      :name => "Wonder Woman",
      :email => "whoops",
      :password => ""
    }
    post '/users/login', params1
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_response.body).to have_content("Dashboard")
    post '/users/login', params2
    expect(last_response.location).to include("/login")
  end


  it 'does not let user view login page if already logged in' do
    user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
    params = {
      :name => "becky567",
      :password => "kittens"
    }
    post '/login', params
    get '/login'
    expect(last_response.location).to include("/tweets")
  end
end

describe "logout" do
  it "lets a user logout if they are already logged in" do
    user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
    params = {
      :name => "becky567",
      :password => "kittens"
    }
    post '/login', params
    get '/logout'
    expect(last_response.location).to include("/login")
  end

  it 'does not let a user logout if not logged in' do
    get '/logout'
    expect(last_response.location).to include("/")
  end

  it 'does not load /dashboard if user not logged in' do
    get '/dashboard'
    expect(last_response.location).to include("/login")
  end

  it 'does load /dashboard if user is logged in' do
    user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
    visit '/login'
    fill_in(:name, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    expect(page.current_path).to eq('/dashboard')
  end
end

describe 'dashboard (user show) page' do
  it 'shows all a single user\'s projects and supplies' do
    user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
    project1 = Project.create(:name => "GGS", :type => "event", :date => "September 1, 2019", :attendees => 100, :supplies => 200.00)
    get "/users/#{user.id}"
    expect(last_response.body).to include("GGS")
    expect(last_response.body).to include("September 1, 2019")

  end
end

context 'logged out' do
  it 'does not let a user view the dashboard if not logged in' do
    get '/dashboard'
    expect(last_response.location).to include("/login")
  end
end
