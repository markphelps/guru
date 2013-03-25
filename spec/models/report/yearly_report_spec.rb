describe Report::YearlyReport do
  before :each do
    @studio = double(:studio)
    allow(@studio).to receive(:created_at).and_return(DateTime.now)
  end

  it 'defaults year to current year if no year provided' do
    expect(Report::YearlyReport.new(@studio, 1).year).to eq Date.current.year
  end

  it 'defaults year to current year if invalid year provided' do
    expect(Report::YearlyReport.new(@studio, 1, 500).year).to eq Date.current.year
  end

  it 'it reports if current year is first_year' do
    expect(Report::YearlyReport.new(@studio, 1, @studio.created_at.to_date.year).first_year?).to be true
  end

  it 'it reports if current year is current_year' do
    expect(Report::YearlyReport.new(@studio, 1, Date.current.year).current_year?).to be true
  end
end
