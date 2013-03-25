require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Edit member settings' do
  before :each do
    login
    visit edit_settings_member_path
  end

  scenario 'with valid parameters' do
    check 'Default Payment Due Day Enabled'
    select '15', from: 'Default Payment Due Day'
    click_button 'Update Settings'
    expect(current_path).to eq(edit_settings_member_path)
    expect(page).to have_content 'Member Settings successfully updated'
    expect(page).to have_content '15'
  end
end
