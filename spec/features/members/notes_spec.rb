require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Add a note' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    visit member_path(member)
    click_link 'New Note'
    fill_in 'member_note_body', with: 'Lorem Ipsum'
    click_button 'Create Note'
    expect(current_path).to eq(member_path(member))
    expect(page).to have_content 'Note was successfully created'
  end
end

feature 'List notes' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    note = create(:member_note, member: member)
    visit member_path(member)
    expect(page).to have_content note.body
  end
end

feature 'Edit note' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    note = create(:member_note, member: member)
    visit edit_member_note_path(member, note)
    expect(page).to have_content note.body
    fill_in 'member_note_body', with: 'Lorem Ipsum'
    click_button 'Update Note'
    expect(current_path).to eq(member_path(member))
    expect(page).to have_content 'Note was successfully updated'
    expect(page).to have_content 'Lorem Ipsum'
  end
end

feature 'Destroy note' do
  scenario do
    user = login
    member = create(:member, studio: user.studio)
    note = create(:member_note, member: member)
    visit edit_member_note_path(member, note)
    expect(page).to have_content note.body
    click_link 'Delete Note'
    expect(page).to have_content 'Note was successfully deleted'
    expect(page).to_not have_content note.body
  end
end
