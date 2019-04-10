require_relative "../spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it 'loads the welcome page' do
    get '/'
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

  it 'signup directs user to signup' do
  params = {
    :username => "bananas123",
    :email => "bananas@aol.com",
    :password => "howgoesit"
  }
  post '/users/signup', params
  expect(last_response.location).to include("/users/signup")
  end

  it 'does not let a user sign up without a username' do
    params = {
      :username => "",
      :email => "banana@aol.com",
      :password => "howgoesit"
    }
    post '/users/signup', params
    expect(last_response.location).to include('/users/signup')
  end

  it 'does not let a user sign up without an email' do
    params = {
      :username => "bananas123",
      :email => "",
      :password => "howgoesit"
    }
    post '/users/signup', params
    expect(last_response.location).to include('/users/signup')
  end

  it 'does not let a user sign up without a password' do
    params = {
      :username => "bananas123",
      :email => "bananas@aol.com",
      :password => ""
    }
    post '/users/signup', params
    expect(last_response.location).to include('/users/signup')
  end

  it 'does not let a user sign up with an invalid email' do
    params = {
      :username => "bananas123",
      :email => "bananas@aol.com",
      :password => ""
    }
    post '/users/login', params
    expect(flash[:error]).to match(/Something went wrong.*/)
    expect(last_response.location).to include('/users/signup')
  end

  it 'creates a new user and logs them in on valid submission and does not let a logged in user view the signup page' do
    params = {
      :username => "bananas123",
      :email => "bananas@aol.com",
      :password => "howgoesit"
    }
    post '/users/login', params
    get '/users/login'
    expect(last_response.location).to include('/login')
  end
end


describe "login" do
  it 'loads the login page' do
    get '/users/login'
    expect(last_response.status).to eq(200)
  end

  it 'loads the dashboard after login' do
    user = User.create(:username => "hullabaloo42", :email => "bananas@aol.com", :password => "galaxy")
    params = {
      :username => "hullabaloo42",
      :password => "galaxy"
    }
    post '/users/login', params
    expect(last_response.status).to eq(302)
    follow_redirect!
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Dashboard")
  end

  it 'does not let user view login page if already logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    params = {
      :username => "becky567",
      :password => "kittens"
    }
    post '/login', params
    get '/login'
    expect(last_response.location).to include("/tweets")
  end
end

describe "logout" do
  it "lets a user logout if they are already logged in" do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

    params = {
      :username => "becky567",
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
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    expect(page.current_path).to eq('/dashboard')
  end
end

describe 'dashboard (user show) page' do
  it 'shows all a single user\'s projects and supplies' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
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

describe 'new action' do
  context 'logged in' do
    it 'lets user view new project form if logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/new'
      expect(page.status_code).to eq(200)
    end

    it 'lets user create a project if they are logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'

      visit '/projects/new'
      fill_in(:name, :with => "Super Science Saturday")
      click_button 'submit'

      user = User.find_by(:username => "becky567")
      tweet = Project.find_by(:name => "Super Science Saturday")
      expect(project).to be_instance_of(Project)
      expect(project.user_id).to eq(user.id)
      expect(page.status_code).to eq(200)
    end

    it 'does not let a user create project from another user' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'

      visit '/projects/new'

      fill_in(:name, :with => "STEM Day")
      click_button 'submit'

      user = User.find_by(:id=> user.id)
      user2 = User.find_by(:id => user2.id)
      project = Project.find_by(:name => "STEM Day")
      expect(project).to be_instance_of(Project)
      expect(project.user_id).to eq(project.id)
      expect(project.user_id).not_to eq(user2.id)
    end

    it 'does not let a user create a blank project' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'

      visit '/projects/new'

      fill_in(:name, :with => "")
      click_button 'submit'

      expect(Project.find_by(:name => "")).to eq(nil)
      expect(page.current_path).to eq("/projects/new")
    end
  end

  context 'logged out' do
    it 'does not let user view new project form if not logged in' do
      get '/projects/new'
      expect(last_response.location).to include("/login")
    end
  end
end

describe 'show action' do
  context 'logged in' do
    it 'displays a single project' do

      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:name => "super duper robotics", :user_id => user.id)

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'

      visit "/projects/#{project.id}"
      expect(page.status_code).to eq(200)
      expect(page.body).to include("Delete Project")
      expect(page.body).to include(project.name)
      expect(page.body).to include("Edit Project")
    end
  end

  context 'logged out' do
    it 'does not let a user view a project' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:name => "super duper robotics", :user_id => user.id)
      get "/projects/#{Project.id}"
      expect(last_response.location).to include("/login")
    end
  end
end

describe 'edit action' do
  context "logged in" do
    it 'lets a user view project edit form if they are logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:content => "tweeting!", :user_id => user.id)
      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/1/edit'
      expect(page.status_code).to eq(200)
      expect(page.body).to include(tweet.content)
    end

    it 'does not let a user edit a project they did not create' do
      user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet1 = Project.create(:name => "super duper robotics", :user_id => user1.id)

      user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
      tweet2 = Project.create(:name => "Family Reunion", :user_id => user2.id)

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit "/projects/#{project2.id}/edit"
      expect(page.current_path).to include('/projects')
    end

    it 'lets a user edit their own project if they are logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      project = Project.create(:name => "Family Reunion", :user_id => 1)
      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/1/edit'

      fill_in(:name, :with => "Super Duper Robotics Day")

      click_button 'submit'
      expect(Project.find_by(:name => "Super Duper Robotics Day")).to be_instance_of(Project)
      expect(Project.find_by(:name => "Family Reunion")).to eq(nil)
      expect(page.status_code).to eq(200)
    end

    it 'does not let a user edit a project with blank content' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      project = Project.create(:name => "Storybook Science A", :user_id => 1)
      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/1/edit'

      fill_in(:name, :with => "")

      click_button 'submit'
      expect(Project.find_by(:name => "i love robots")).to be(nil)
      expect(page.current_path).to eq("/projects/1/edit")
    end
  end

  context "logged out" do
    it 'does not load -- instead redirects to login' do
      get '/projects/1/edit'
      expect(last_response.location).to include("/login")
    end
  end
end

describe 'delete action' do
  context "logged in" do
    it 'lets a user delete their own projects if they are logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Project.create(:name => "Volcanos", :user_id => 1)
      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit 'tweets/1'
      click_button "Delete Project"
      expect(page.status_code).to eq(200)
      expect(Project.find_by(:name => "Volcanoes")).to eq(nil)
    end

    it 'does not let a user delete a project they did not create' do
      user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      project1 = Project.create(:name => "Science Night Out", :user_id => user1.id)

      user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
      project2 = Project.create(:name => "Staff Meeting", :user_id => user2.id)

      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit "projects/#{project2.id}"
      click_button "Delete Project"
      expect(page.status_code).to eq(200)
      expect(Project.find_by(:name => "Science Night Out")).to be_instance_of(Project)
      expect(page.current_path).to include('/projects')
    end
  end

  context "logged out" do
    it 'does not let user delete a project if not logged in' do
      project = Project.create(:name => "Flora Singer Week 2", :user_id => 1)
      visit '/projects/1'
      expect(page.current_path).to eq("/login")
    end
  end
end
