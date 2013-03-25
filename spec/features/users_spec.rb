require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Login user' do
  scenario 'existing user' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
    expect(current_path).to eq(root_path)
    expect(page).to have_content user.studio.name
  end

  scenario 'non-existing user' do
    visit new_user_session_path
    fill_in 'Email', with: 'blah'
    fill_in 'Password', with: 'blah'
    click_button 'Sign In'
    expect(current_path).to eq(new_user_session_path)
  end
end