require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Add a visit' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
    @klass = create(:klass, studio: user.studio)
  end

  scenario 'with valid parameters' do
    visit new_member_visit_path(@member)
    expect(page).to have_content @member.name
    expect(find_field('Date').value).to eq(Date.current.strftime('%m/%d/%Y'))
    select @klass.name_day_and_time, from: 'Class'
    click_button 'Create Visit'
    expect(current_path).to eq(member_visits_path(@member))
    expect(page).to have_content 'Visit was successfully created'
  end
end

feature 'Edit existing visit' do
  before :each do
    @user = login
    @member = create(:member, studio: @user.studio)
    klass = create(:klass, studio: @user.studio)
    @visit = create(:visit, member: @member, klass: klass)
  end

  scenario 'with valid parameters' do
    klass = create(:klass, name: 'Mark', studio: @user.studio)
    visit edit_member_visit_path(@member, @visit)
    fill_in 'Date', with: Date.current.strftime('%m/%d/%Y')
    select klass.name_day_and_time, from: 'Class'
    click_button 'Update Visit'
    expect(current_path).to eq(member_visits_path(@member))
    expect(page).to have_content 'Visit was successfully updated'
  end

  scenario 'with invalid parameters' do
    visit edit_member_visit_path(@member, @visit)
    fill_in 'Date', with: nil
    click_button 'Update Visit'
    expect(page).to have_content 'Visit date is not a valid date'
  end
end

feature 'Destroy visit' do
  scenario 'existing visit' do
    user = login
    member = create(:member, studio: user.studio)
    klass = create(:klass, studio: user.studio)
    visit = create(:visit, member: member, klass: klass)
    visit edit_member_visit_path(member, visit)
    click_link 'Delete Visit'
    expect(current_path).to eq(member_visits_path(member))
    expect(page).to have_content 'Visit was successfully deleted'
  end
end

feature 'Download visits CSV' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    klass = create(:klass, studio: user.studio)
    create(:visit, member: member, klass: klass)
    filename = "#{member.name.parameterize('_')}_visits_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_member_visits_path member
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
