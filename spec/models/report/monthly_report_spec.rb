require 'spec_helper'

describe Report::MonthlyReport do
  before :each do
    @studio = double(:studio)
  end

  it 'defaults month to current month if no month provided' do
    expect(Report::MonthlyReport.new(@studio).month).to eq Date.current.month
  end

  it 'defaults month to current month if invalid month provided' do
    expect(Report::MonthlyReport.new(@studio, 500).month).to eq Date.current.month
  end

  it 'allows valid months' do
    expect(Report::MonthlyReport.new(@studio, 1).month).to eq 1
    expect(Report::MonthlyReport.new(@studio, 12).month).to eq 12
  end

  it 'returns the month name' do
    expect(Report::MonthlyReport.new(@studio, 1).month_name).to eq 'January'
    expect(Report::MonthlyReport.new(@studio, 12).month_name).to eq 'December'
  end

  it 'it reports if current month is January' do
    expect(Report::MonthlyReport.new(@studio, 1).january?).to be true
    expect(Report::MonthlyReport.new(@studio, 12).january?).to be false
  end

  it 'it reports if current month is December' do
    expect(Report::MonthlyReport.new(@studio, 1).december?).to be false
    expect(Report::MonthlyReport.new(@studio, 12).december?).to be true
  end

  it 'computes next month' do
    expect(Report::MonthlyReport.new(@studio, 1).next_month).to eq 2
    expect(Report::MonthlyReport.new(@studio, 12).next_month).to eq 12
  end

  it 'computes previous month' do
    expect(Report::MonthlyReport.new(@studio, 1).prev_month).to eq 1
    expect(Report::MonthlyReport.new(@studio, 12).prev_month).to eq 11
  end
end
