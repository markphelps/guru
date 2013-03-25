require 'spec_helper'

describe Report::Member::BirthdayReport do
  before :each do
    @studio = create(:studio)
  end

  it 'has birthday report' do
    create(:member, studio: @studio, birthday: Date.current)
    expect(Report::Member::BirthdayReport.new(@studio).members).to_not be_empty
  end

  it 'filters dates for birthday report' do
    create(:member, studio: @studio, birthday: Date.current << 1)
    expect(Report::Member::BirthdayReport.new(@studio).members).to be_empty
  end
end
