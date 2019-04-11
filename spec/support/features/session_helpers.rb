# spec/support/features/session_helpers.rb
module Features
  module SessionHelpers
    def sign_up_with(name, email, password)
      visit /users/signup
      fill_in 'Name', with: "Lily Potter."
      fill_in 'Email', with: "potter@hogwarts.com"
      fill_in 'Password', with: password
      click_button 'Sign up'
    end

    def sign_in
      user = create(:user)
      visit /users/login
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'
    end
  end
end
