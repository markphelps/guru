require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create new member' do
  before :each do
    login
    visit new_member_path
  end

  scenario 'with valid parameters' do
    fill_in 'First Name', with: 'Mark'
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Street Address', with: '123 Fake Street'
    fill_in 'City', with: 'Durham'
    select 'North Carolina', from: 'State'
    fill_in 'Zip', with: '27701'
    fill_in 'Phone', with: '(555)-555-5555'
    fill_in 'Email', with: 'mark.aaron.phelps@gmail.com'
    fill_in 'Birthday', with: '11/01/1985'
    fill_in 'Start Date', with: '12/12/2012'
    fill_in 'Membership Price', with: '50.00'
    check 'Active'
    click_button 'Create Member'
    expect(page).to have_content 'Member was successfully created'
    expect(page).to have_content 'Mark Phelps'
  end

  scenario 'with invalid parameters' do
    fill_in 'First Name', with: nil
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Phone', with: '(555)-555-5555'
    fill_in 'Email', with: 'mark.aaron.phelps@gmail.com'
    click_button 'Create Member'
    expect(page).to have_content "First name can't be blank"
  end
end

feature 'Edit existing member' do
  before :each do
    user = login
    member = create(:member, studio: user.studio)
    visit edit_member_path(member)
  end

  scenario 'with valid parameters' do
    fill_in 'First Name', with: 'John'
    fill_in 'Last Name', with: 'Phelps'
    fill_in 'Phone', with: '(757) 555-5555'
    fill_in 'Email', with: 'john.phelps@gmail.com'
    click_button 'Update Member'
    expect(page).to have_content 'Member was successfully updated'
    expect(page).to have_content 'John Phelps'
  end

  scenario 'with invalid parameters' do
    fill_in 'First Name', with: nil
    click_button 'Update Member'
    expect(page).to have_content "First name can't be blank"
  end
end

feature 'Show member' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    visit member_path(member)
    expect(page).to have_content member.name
  end
end

feature 'Destroy member' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    visit edit_member_path(member)
    expect(page).to have_content member.name
    click_link 'Delete Member'
    expect(page).to have_content 'Member was successfully deleted'
    expect(page).to_not have_content member.name
  end
end

feature 'Destroy mutiple' do
  scenario do
    user = login
    member1 = create(:member, studio: user.studio)
    member2 = create(:member, studio: user.studio)
    member3 = create(:member, studio: user.studio)
    visit members_path
    expect(page).to have_content member1.name
    expect(page).to have_content member2.name
    expect(page).to have_content member3.name
    check "member_id_#{member1.id}"
    check "member_id_#{member2.id}"
    click_button 'Delete Members'
    expect(page).to have_content 'Members successfully deleted'
    expect(page).to have_content member3.name
    expect(page).to_not have_content member1.name
    expect(page).to_not have_content member2.name
  end
end

feature 'List members' do
  scenario 'with one member' do
    user = login
    member = create(:member, studio: user.studio)
    visit members_path
    expect(page).to have_content member.name
    expect(page).to have_content 'Import Members'
  end

  scenario 'with zero members' do
    login
    visit members_path
    expect(page).to_not have_content 'Import Members'
  end

  scenario 'only inactive members' do
    user = login
    inactive = create(:member, active: false, studio: user.studio)
    active = create(:member, active: true, studio: user.studio)
    visit inactive_members_path
    expect(page).to have_content inactive.name
    expect(page).to_not have_content active.name
  end

  scenario 'only active members' do
    user = login
    inactive = create(:member, active: false, studio: user.studio)
    active = create(:member, active: true, studio: user.studio)
    visit active_members_path
    expect(page).to_not have_content inactive.name
    expect(page).to have_content active.name
  end
end

feature 'Add level to member' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    level = create(:level, studio: user.studio)
    visit edit_member_path(member)
    select level.name, from: 'member_level_id'
    click_button 'Update Member'
    expect(page).to have_content 'Member was successfully updated'
    expect(page).to have_content level.name
  end
end

feature 'Add source to member' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    source = create(:source, studio: user.studio)
    visit edit_member_path(member)
    select source.name, from: 'member_source_id'
    click_button 'Update Member'
    expect(page).to have_content 'Member was successfully updated'
    expect(page).to have_content source.name
  end
end

feature 'Download members CSV' do
  scenario do
    user = login
    create(:member, studio: user.studio)
    filename = "members_#{Date.current.strftime('%Y%m%d')}.csv"
    visit export_members_path
    expect(page.response_headers['Content-Disposition']).to include("filename=\"#{filename}\"")
  end
end
