require 'spec_helper'

describe Report::Member::RecentReport do
  it 'lists members created in last 90 days' do
    studio = create(:studio)
    create(:member, studio: studio)
    expect(Report::Member::RecentReport.new(studio).members.count).to eq 1
  end

  it 'doesnt list members created more than 90 days ago' do
    studio = create(:studio)
    create(:member, studio: studio, created_at: 91.days.ago)
    expect(Report::Member::RecentReport.new(studio).members.count).to eq 0
  end
end
