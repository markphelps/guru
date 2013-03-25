require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create new level' do
  before :each do
    login
    visit new_level_path
  end

  scenario 'with valid parameters' do
    fill_in 'Name', with: 'Black Belt'
    fill_in 'Color', with: '#000000'
    click_button 'Create Level'
    expect(current_path).to eq(levels_path)
    expect(page).to have_content 'Level was successfully created'
    expect(page).to have_content 'Black Belt'
    expect(page).to have_content '0'
  end
end

feature 'Edit existing level' do
  before :each do
    user = login
    level = create(:level, studio: user.studio)
    visit edit_level_path(level)
  end

  scenario 'with valid parameters' do
    fill_in 'Name', with: 'White Belt'
    fill_in 'Color', with: '#ffffff'
    click_button 'Update Level'
    expect(current_path).to eq(levels_path)
    expect(page).to have_content 'Level was successfully updated'
    expect(page).to have_content 'White Belt'
  end

  scenario 'with invalid parameters' do
    fill_in 'Name', with: nil
    click_button 'Update Level'
    expect(page).to have_content "Name can't be blank"
  end
end

feature 'Destroy level' do
  scenario 'successfully' do
    user = login
    level = create(:level, studio: user.studio)
    visit edit_level_path(level)
    click_link 'Delete Level'
    expect(current_path).to eq(levels_path)
    expect(page).to have_content 'Level was successfully deleted'
    expect(page).to_not have_content level.name
  end
end

feature 'Download levels CSV' do
  scenario do
    user = login
    create(:level, studio: user.studio)
    filename = "levels_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_levels_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
