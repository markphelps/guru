require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Shows recent members' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
  end

  scenario 'in past 90 days' do
    visit reports_members_recent_path
    expect(page).to have_content @member.name
  end

  scenario 'not in past 90 days' do
    Timecop.freeze(Date.current + 91) do
      visit reports_members_recent_path
      expect(page).to_not have_content @member.name
    end
  end
end

feature 'Download recent members CSV' do
  scenario do
    user = login
    create(:member, studio: user.studio)
    filename = "recent_members_#{Date.current.strftime('%Y%m%d')}.csv"
    visit reports_members_recent_export_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
