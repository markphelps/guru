require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Shows member birthdays' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio, birthday: Date.current)
  end

  scenario 'this month' do
    visit reports_members_birthdays_path
    expect(page).to have_content Date::MONTHNAMES[Date.current.month]
    expect(page).to have_content @member.name
  end

  scenario 'next month' do
    future = Date.current >> 1
    visit reports_members_birthdays_path(month: future.month)
    expect(page).to have_content Date::MONTHNAMES[future.month]
    expect(page).to_not have_content @member.name
  end

  scenario 'previous month' do
    past = Date.current << 1
    visit reports_members_birthdays_path(month: past.month)
    expect(page).to have_content Date::MONTHNAMES[past.month]
    expect(page).to_not have_content @member.name
  end
end

feature 'Download member birthdays CSV' do
  scenario do
    user = login
    create(:member, studio: user.studio, birthday: Date.current)
    filename = "#{Date::ABBR_MONTHNAMES[Date.current.month].downcase}_birthdays_#{Date.current.strftime('%Y%m%d')}.csv"
    visit reports_members_birthdays_export_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
