require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create source' do
  before :each do
    login
    visit sources_path
  end

  scenario 'with valid parameters' do
    click_link 'New Source'
    expect(current_path).to eq(new_source_path)
    fill_in 'Source', with: 'Test'
    click_button 'Create Source'
    expect(page).to have_content 'Source successfully created'
    expect(page).to have_content 'Test'
    expect(current_path).to eq sources_path
  end

  scenario 'with invalid parameters' do
    click_link 'New Source'
    expect(current_path).to eq(new_source_path)
    click_button 'Create Source'
    expect(page).to have_content "Name can't be blank"
  end
end

feature 'Edit existing source' do
  before :each do
    user = login
    source = create(:source, studio: user.studio)
    visit edit_source_path(source)
  end

  scenario 'with valid parameters' do
    fill_in 'Source', with: 'Test'
    click_button 'Update Source'
    expect(page).to have_content 'Source successfully updated'
    expect(page).to have_content 'Test'
    expect(current_path).to eq sources_path
  end

  scenario 'with invalid parameters' do
    fill_in 'Source', with: ''
    click_button 'Update Source'
    expect(page).to have_content "Name can't be blank"
  end
end

feature 'Delete existing source' do
  scenario do
    user = login
    source = create(:source, studio: user.studio)
    visit edit_source_path(source)
    click_link 'Delete Source'
    expect(page).to have_content 'Source successfully deleted'
    expect(page).to_not have_content 'Test'
    expect(current_path).to eq sources_path
  end
end

feature 'Download sources CSV' do
  scenario do
    user = login
    create(:source, studio: user.studio)
    filename = "sources_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_sources_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
