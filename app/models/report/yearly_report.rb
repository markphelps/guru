class Report::YearlyReport < Report::MonthlyReport
  attr_reader :year

  def initialize(studio, month = Date.current.month, year = Date.current.year)
    super(studio, month)
    @year = (studio.created_at.to_date.year..Date.current.year).include?(year.to_i) ? year.to_i : Date.current.year
  end

  def next_year
    @year + 1 > Date.current.year ? @year : @year + 1
  end

  def prev_year
    @year - 1 < @studio.created_at.to_date.year ? @year : @year - 1
  end

  def first_year?
    @year == @studio.created_at.to_date.year
  end

  def current_year?
    @year == Date.current.year
  end
end
