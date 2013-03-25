require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Make a payment' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
  end

  scenario 'with valid parameters' do
    create(:account, member: @member)
    visit new_member_payment_path(@member)
    expect(page).to have_content @member.name
    expect(find_field('Payment Date').value).to eq(Date.current.strftime('%m/%d/%Y'))
    expect(find_field('Payment Amount').value).to eq(number_to_currency(@member.account_balance, unit: ''))
    expect(find_field('Method').value).to eq('check')
    click_button 'Create Payment'
    expect(current_path).to eq(member_payments_path(@member))
    expect(page).to have_content 'Payment was successfully created'
  end

  scenario 'with no account' do
    visit new_member_payment_path(@member)
    expect(current_path).to eq (new_member_account_path(@member))
    expect(page).to have_content "Account not found for #{@member.name}. Please create one."
  end
end

feature 'List payments' do
  scenario 'with account' do
    create(:account, member: @member)
    user = login
    member = create(:member, studio: user.studio)
    account = create(:account, member: member)
    payment = create(:payment, account: account)
    visit member_payments_path member
    expect(page).to have_content payment.payment_date.strftime('%m/%d/%Y')
    expect(page).to have_content number_to_currency(payment.payment_amount)
    expect(page).to have_content payment.due_date.strftime('%m/%d/%Y')
    expect(page).to have_content number_to_currency(payment.amount_due)
    expect(page).to have_content payment.payment_method.to_s.capitalize
  end
end

feature 'Delete payment' do
  scenario 'with account' do
    create(:account, member: @member)
    user = login
    member = create(:member, studio: user.studio)
    account = create(:account, member: member)
    payment = create(:payment, account: account)
    visit member_payments_path member
    find(:xpath, "//tr[td[contains(.,'" + payment.payment_date.strftime('%m/%d/%Y') + "')]]/td/a[@href='" + member_payment_path(member, payment) + "']").click
    expect(current_path).to eq(member_payments_path(member))
    expect(page).to have_content 'Payment was successfully deleted'
    expect(page).to_not have_content payment.payment_date.strftime('%m/%d/%Y')
  end
end

feature 'Download payments CSV' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    account = create(:account, member: member)
    create(:payment, account: account)
    filename = "#{member.name.parameterize('_')}_payments_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_member_payments_path member
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
