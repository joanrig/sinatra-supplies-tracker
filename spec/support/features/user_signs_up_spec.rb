require 'spec_helper'

feature 'Visitor signs up' do
  scenario 'with name, valid email and password' do
    sign_up_with 'Lily Potter', 'potter@hogwarts.com', 'password'
    expect(page).to have_content('dashboard')
  end

  scenario 'with invalid email' do
    sign_up_with 'invalid_email', 'password'
    expect(page).to have_content('Something went wrong')
  end

  scenario 'with blank password' do
    sign_up_with 'valid@example.com', ''
    expect(page).to have_content('Something went wrong')
  end

end
