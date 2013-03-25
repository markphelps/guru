require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Shows accounts' do
  before :each do
    user = login
    @studio = user.studio
    @member = create(:member, studio: @studio)
  end

  scenario 'all accounts' do
    create(:account, member: @member)
    visit reports_accounts_path
    expect(page).to have_content @member.name
  end

  scenario 'due accounts' do
    create(:due_account, member: @member)
    up_to_date = create(:member, studio: @studio)
    create(:up_to_date_account, member: up_to_date)
    visit reports_accounts_path(type: :due)
    expect(page).to have_content @member.name
    expect(page).to_not have_content up_to_date.name
  end

  scenario 'up_to_date accounts' do
    create(:up_to_date_account, member: @member)
    due = create(:member, studio: @studio)
    create(:due_account, member: due)
    visit reports_accounts_path(type: :up_to_date)
    expect(page).to have_content @member.name
    expect(page).to_not have_content due.name
  end

  scenario 'past_due accounts' do
    create(:past_due_account, member: @member)
    due = create(:member, studio: @studio)
    create(:due_account, member: due)
    visit reports_accounts_path(type: :past_due)
    expect(page).to have_content @member.name
    expect(page).to_not have_content due.name
  end
end

feature 'Download accounts CSV' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    create(:account, member: member)
    filename = "all_accounts_#{Date.current.strftime('%Y%m%d')}.csv"
    visit reports_accounts_export_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
