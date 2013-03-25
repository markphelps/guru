require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create new user' do
  before :each do
    login
    visit new_settings_user_path
  end

  scenario 'with valid parameters' do
    fill_in 'First Name', with: 'Mark'
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Phone', with: '(555)-555-5555'
    fill_in 'Email', with: 'mark.aaron.phelps@gmail.com'
    fill_in 'user_password', with: 'securepassword'
    fill_in 'user_password_confirmation', with: 'securepassword'
    click_button 'Create User'
    expect(current_path).to eq(settings_users_path)
    expect(page).to have_content 'User successfully created'
    expect(page).to have_content 'Mark Phelps'
  end

  scenario 'with invalid parameters' do
    fill_in 'First Name', with: nil
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Phone', with: '(555)-555-5555'
    fill_in 'Email', with: 'mark.aaron.phelps@gmail.com'
    fill_in 'user_password', with: 'securepassword'
    fill_in 'user_password_confirmation', with: 'securepassword'
    click_button 'Create User'
    expect(page).to have_content "First name can't be blank"
  end
end

feature 'Edit existing user' do
  before :each do
    user = login
    visit edit_settings_user_path user
  end

  scenario 'with valid parameters' do
    fill_in 'First Name', with: 'John'
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Phone', with: '(757)-555-5555'
    fill_in 'Email', with: 'john.phelps@gmail.com'
    click_button 'Update User'
    expect(current_path).to eq(settings_users_path)
    expect(page).to have_content 'User successfully updated'
    expect(page).to have_content 'John Phelps'
  end

  scenario 'with invalid parameters' do
    fill_in 'First Name', with: nil
    click_button 'Update User'
    expect(page).to have_content "First name can't be blank"
  end
end

feature 'Destroy user' do

  scenario 'new user' do
    owner = login(owner: true)
    user = create(:user, studio: owner.studio)
    visit settings_users_path
    find(:xpath, "//tr[td[contains(.,'" + user.email + "')]]/td/a[@href='" + settings_user_path(user) + "']").click
    expect(current_path).to eq(settings_users_path)
    expect(page).to have_content 'User successfully deleted'
    expect(page).to_not have_content user.name
  end

  scenario 'cannot destroy owner' do
    user = login(owner: true)
    visit settings_users_path
    expect(page).to have_content user.email
    expect(page).to_not have_content 'Destroy'
  end

  scenario 'cannot destroy only user' do
    user = login
    visit settings_users_path
    expect(page).to have_content user.email
    expect(page).to_not have_content 'Destroy'
  end
end
