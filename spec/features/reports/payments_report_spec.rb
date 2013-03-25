require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Shows member payments' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
    account = create(:account, member: @member)
    @payment = create(:payment, account: account)
  end

  scenario 'this month' do
    visit reports_payments_path
    expect(page).to have_content @member.name
    expect(page).to have_content @payment.payment_date.strftime('%m/%d/%Y')
    expect(page).to have_content @payment.payment_amount
  end

  scenario 'next month' do
    future = Date.current >> 1
    visit reports_payments_path(year: future.year, month: future.month)
    expect(page).to have_content future.year
    expect(page).to have_content Date::MONTHNAMES[future.month]
    expect(page).to_not have_content @member.name
  end

  scenario 'previous month' do
    Timecop.freeze(Date.new(2014, 2, 1)) do
      past = Date.current << 1
      visit reports_payments_path(year: past.year, month: past.month)
      expect(page).to have_content past.year
      expect(page).to have_content Date::MONTHNAMES[past.month]
      expect(page).to_not have_content @member.name
    end
  end
end

feature 'Download payments CSV' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    account = create(:account, member: member)
    create(:payment, account: account)
    filename = "#{Date::ABBR_MONTHNAMES[Date.current.month].downcase}_payments_#{Date.current.strftime('%Y%m%d')}.csv"
    visit reports_payments_export_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
