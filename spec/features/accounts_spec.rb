require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create new account' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
  end

  scenario 'with valid parameters' do
    visit new_member_account_path(@member)
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.strftime('%m/%d/%Y')
    fill_in 'Balance', with: number_to_currency(@member.membership_price, unit: '')
    click_button 'Create Account'
    expect(current_path).to eq member_path(@member)
    expect(page).to have_content 'Account was successfully created'
  end

  scenario 'with invalid parameters' do
    visit new_member_account_path(@member)
    expect(page).to have_content @member.name
    click_button 'Create Account'
    expect(current_path).to eq(member_account_path(@member))
    expect(page).to have_content 'Balance can\'t be blank'
  end

  scenario 'with an existing account' do
    create(:account, member: @member)
    visit new_member_account_path(@member)
    expect(page).to have_content "An account already exists for #{@member.name}"
    expect(current_path).to eq member_path(@member)
  end
end

feature 'Edit an account' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
    create(:account, member: @member)
  end

  scenario 'with valid parameters' do
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.next_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Account was successfully updated'
    expect(page).to have_content Date.current.next_month.strftime('%m/%d/%Y')
  end

  scenario 'with invalid parameters' do
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: ''
    click_button 'Update Account'
    expect(current_path).to eq(member_account_path(@member))
    expect(page).to have_content 'Payment due date is not a valid date'
  end
end

feature 'Change due date' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
  end

  scenario 'up_to_date account to due date in future' do
    create(:up_to_date_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.next_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'up_to_date account to due date in past' do
    create(:up_to_date_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.prev_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'due_account to due date in future' do
    create(:due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.next_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Due'
  end

  scenario 'due_account to due date in past' do
    create(:due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.prev_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Past Due'
  end

  scenario 'past_due_account to due date in future' do
    create(:past_due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.next_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Due'
  end

  scenario 'past_due_account to due date in past' do
    create(:past_due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Payment Due Date', with: Date.current.prev_month.strftime('%m/%d/%Y')
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Past Due'
  end
end

feature 'Change balance' do
  before :each do
    user = login
    @member = create(:member, studio: user.studio)
  end

  scenario 'up_to_date account with positive balance' do
    create(:up_to_date_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: 1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Due'
  end

  scenario 'up_to_date account with negative balance' do
    create(:up_to_date_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: -1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'due_account with positive balance' do
    create(:due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: 1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Due'
  end

  scenario 'due_account with negative balance' do
    create(:due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: -1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'due_account with zero balance' do
    create(:due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: 0.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'past_due_account with positive balance' do
    create(:past_due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: 1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Past Due'
  end

  scenario 'past_due_account with negative balance' do
    create(:past_due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: -1.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end

  scenario 'due_account with zero balance' do
    create(:past_due_account, member: @member)
    visit edit_member_account_path @member
    expect(page).to have_content @member.name
    fill_in 'Balance', with: 0.00
    click_button 'Update Account'
    expect(current_path).to eq(member_path(@member))
    expect(page).to have_content 'Up To Date'
  end
end
