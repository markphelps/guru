require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Edit existing studio' do
  before :each do
    login
    visit edit_settings_studio_path
  end

  scenario 'with valid parameters' do
    fill_in 'City', with: 'San Francisco'
    select 'California', from: 'State'
    fill_in 'Zip', with: '90210'
    click_button 'Update Studio'
    expect(current_path).to eq(edit_settings_studio_path)
    expect(page).to have_content 'Studio was successfully updated'
  end

  scenario 'with invalid parameters' do
    fill_in 'Name', with: nil
    fill_in 'City', with: 'San Francisco'
    select 'California', from: 'State'
    fill_in 'Zip', with: '90210'
    click_button 'Update Studio'
    expect(page).to have_content "Name can't be blank"
  end
end
