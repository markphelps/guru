class Report::AttendanceReport < Report::YearlyReport
  def members
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.next_month.at_beginning_of_month
    @studio.members
      .select('members.*')
      .joins('LEFT OUTER JOIN visits on members.id = visits.member_id')
      .select('MAX(visits.id), COUNT(visits.id) AS visits_count, MAX(DATE(visits.visit_date)) AS visit_date')
      .where('visits.visit_date >= ? AND visits.visit_date < ?', start_date, end_date)
      .group('members.id')
  end

  def name
    "#{month_name} Attendance"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(First\ Name Last\ Name Last\ Visit Visits)
      members.each do |member|
        csv << [member.first_name, member.last_name, member.visit_date.to_date.strftime('%m/%d/%Y'), member.visits_count]
      end
    end
  end

  def filename
    "#{Date::ABBR_MONTHNAMES[@month].downcase}_attendance.csv"
  end
end
