class Report::MonthlyReport
  attr_reader :month
  attr_reader :studio

  def initialize(studio, month = Date.current.month)
    @studio = studio
    @month = (1..12).include?(month.to_i) ? month.to_i : Date.current.month
  end

  def next_month
    @month + 1 > 12 ? @month : @month + 1
  end

  def prev_month
    @month - 1 < 1 ? @month : @month - 1
  end

  def month_name
    Date::MONTHNAMES[@month]
  end

  def january?
    @month == 1
  end

  def december?
    @month == 12
  end
end
