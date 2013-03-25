class Report::BirthdayReport < Report::MonthlyReport
  def birthdays
    @studio.members.birthdays(@month)
  end

  def name
    "#{month_name} Birthdays"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(First\ Name Last\ Name Phone Email Birthday Date\ Added)
      birthdays.each do |member|
        csv << [member.first_name, member.last_name, member.try(:phone), member.try(:email), member.try(:birthday).try(:strftime, '%m/%d/%Y'), member.created_at.strftime('%m/%d/%Y')]
      end
    end
  end

  def filename
    "#{Date::ABBR_MONTHNAMES[@month].downcase}_birthdays.csv"
  end
end
