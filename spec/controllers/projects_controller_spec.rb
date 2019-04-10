require_relative "../spec_helper"

def app
  ProjectsController
end

describe 'new action' do
  context 'logged in' do
    it 'lets user view new project form if logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:name, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/new'
      expect(page.status_code).to eq(200)
    end

    it 'lets user create a project if they are logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:name, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'

      visit '/projects/new'
      fill_in(:name, :with => "Super Science Saturday")
      click_button 'submit'

      user = User.find_by(:name => "becky567")
      tweet = Project.find_by(:name => "Super Science Saturday")
      expect(project).to be_instance_of(Project)
      expect(project.user_id).to eq(user.id)
      expect(page.status_code).to eq(200)
    end

    it 'does not let a user create project from another user' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")

     visit '/login'

      fill_in(:name, :with => "becky567")
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
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")

      visit '/login'

      fill_in(:name, :with => "becky567")
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

      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:name => "super duper robotics", :user_id => user.id)

      visit '/login'

      fill_in(:name, :with => "becky567")
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
    it 'does not let a user view a project if logged out' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:name => "super duper robotics", :user_id => user.id)
      get "/projects/#{Project.id}"
      expect(last_response.location).to include("/login")
    end
  end
end

describe 'edit action' do
  context "logged in" do
    it 'lets a user view project edit form if they are logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Tweet.create(:content => "tweeting!", :user_id => user.id)
      visit '/login'

      fill_in(:name, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit '/projects/1/edit'
      expect(page.status_code).to eq(200)
      expect(page.body).to include(tweet.content)
    end

    it 'does not let a user edit a project they did not create' do
      user1 = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet1 = Project.create(:name => "super duper robotics", :user_id => user1.id)

      user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")
      tweet2 = Project.create(:name => "Family Reunion", :user_id => user2.id)

      visit '/login'

      fill_in(:name, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit "/projects/#{project2.id}/edit"
      expect(page.current_path).to include('/projects')
    end

    it 'lets a user edit their own project if they are logged in' do
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      project = Project.create(:name => "Family Reunion", :user_id => 1)
      visit '/login'

      fill_in(:name, :with => "becky567")
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
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      project = Project.create(:name => "Storybook Science A", :user_id => 1)
      visit '/login'

      fill_in(:name, :with => "becky567")
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
      user = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      tweet = Project.create(:name => "Volcanos", :user_id => 1)
      visit '/login'

      fill_in(:name, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      visit 'tweets/1'
      click_button "Delete Project"
      expect(page.status_code).to eq(200)
      expect(Project.find_by(:name => "Volcanoes")).to eq(nil)
    end

    it 'does not let a user delete a project they did not create' do
      user1 = User.create(:name => "becky567", :email => "starz@aol.com", :password => "kittens")
      project1 = Project.create(:name => "Science Night Out", :user_id => user1.id)

      user2 = User.create(:name => "silverstallion", :email => "silver@aol.com", :password => "horses")
      project2 = Project.create(:name => "Staff Meeting", :user_id => user2.id)

      visit '/login'

      fill_in(:name, :with => "becky567")
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
