class Visit::CsvExport
  def initialize(member)
    @member = member
  end

  def filename
    "#{@member.name}_visits.csv"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Visit\ Date Class Time)
      @member.visits.each do |visit|
        unless visit.klass.nil?
          csv << [visit.visit_date.strftime('%m/%d/%Y'), visit.klass.name, visit.klass.class_time.in_time_zone.strftime('%-l:%M %p')]
        end
      end
    end
  end
end
