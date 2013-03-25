require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Shows member attendance' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
    klass = create(:klass, studio: user.studio)
    @visit = create(:visit, member: @member, klass: klass)
  end

  scenario 'this month' do
    visit reports_attendance_path
    expect(page).to have_content @member.name
    expect(page).to have_content @visit.visit_date.strftime('%m/%d/%Y')
  end

  scenario 'next month' do
    future = Date.current >> 1
    visit reports_attendance_path(year: future.year, month: future.month)
    expect(page).to have_content future.year
    expect(page).to have_content Date::MONTHNAMES[future.month]
    expect(page).to_not have_content @member.name
  end

  scenario 'previous month' do
    Timecop.freeze(Date.new(2014, 2, 1)) do
      past = Date.current << 1
      visit reports_attendance_path(year: past.year, month: past.month)
      expect(page).to have_content past.year
      expect(page).to have_content Date::MONTHNAMES[past.month]
      expect(page).to_not have_content @member.name
    end
  end
end

feature 'Download visits CSV' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    klass = create(:klass, studio: user.studio)
    create(:visit, member: member, klass: klass)
    filename = "#{Date::ABBR_MONTHNAMES[Date.current.month].downcase}_attendance_#{Date.current.strftime('%Y%m%d')}.csv"
    visit reports_attendance_export_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
