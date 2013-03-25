class Klass::CsvExport
  def initialize(klasses)
    @klasses = klasses
  end

  def filename
    'classes.csv'
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Name Day\ of\ Week Time Recurring)
      @klasses.each do |klass|
        csv << [klass.name, klass.day_of_week, klass.class_time.in_time_zone.strftime('%l:%M %p'), klass.recurring]
      end
    end
  end
end
