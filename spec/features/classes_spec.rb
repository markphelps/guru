require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create new class' do
  before :each do
    login
    visit new_class_path
  end

  scenario 'with valid parameters' do
    fill_in 'Name', with: 'Black Belt Class'
    select 'Monday', from: 'Day of week'
    select '07 PM', from: 'klass_class_time_4i'
    check 'Recurring'
    click_button 'Create Class'
    expect(current_path).to eq(classes_path)
    expect(page).to have_content 'Class was successfully created'
    expect(page).to have_content 'Black Belt Class'
  end

  scenario 'with invalid parameters' do
    fill_in 'Name', with: nil
    select 'Monday', from: 'Day of week'
    select '07 PM', from: 'klass_class_time_4i'
    check 'Recurring'
    click_button 'Create Class'
    expect(page).to have_content "Name can't be blank"
  end
end

feature 'Edit existing class' do
  before :each do
    user = login
    klass = create(:klass, studio: user.studio)
    visit edit_class_path(klass)
  end

  scenario 'with valid parameters' do
    fill_in 'Name', with: 'Black Belt Class'
    select 'Monday', from: 'Day of week'
    select '07 PM', from: 'klass_class_time_4i'
    check 'Recurring'
    click_button 'Update Class'
    expect(current_path).to eq(classes_path)
    expect(page).to have_content 'Class was successfully updated'
    expect(page).to have_content 'Black Belt Class'
  end

  scenario 'with invalid parameters' do
    fill_in 'Name', with: nil
    click_button 'Update Class'
    expect(page).to have_content "Name can't be blank"
  end
end

feature 'Destroy class' do
  scenario 'successfully' do
    user = login
    klass = create(:klass, studio: user.studio)
    visit edit_class_path(klass)
    click_link 'Delete Class'
    expect(current_path).to eq(classes_path)
    expect(page).to have_content 'Class was successfully deleted'
    expect(page).to_not have_content klass.name
  end
end

feature 'Download classes CSV' do
  scenario do
    user = login
    create(:klass, studio: user.studio)
    filename = "classes_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_classes_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end

