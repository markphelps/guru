require 'spec_helper'

describe Report::AttendanceReport do
  before :each do
    @studio = create(:studio)
    @member = create(:member, studio: @studio)
  end

  it 'has monthly visit report' do
    create(:visit, member: @member)
    expect(Report::AttendanceReport.new(@studio).members).to_not be_empty
  end

  it 'filters dates for monthly visit report' do
    create(:visit, member: @member, visit_date: 2.years.ago)
    expect(Report::AttendanceReport.new(@studio).members).to be_empty
  end
end
