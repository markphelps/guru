class Level::CsvExport
  def initialize(levels)
    @levels = levels
  end

  def filename
    'levels.csv'
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Name Color Members)
      @levels.each do |level|
        csv << [level.name, level.color, level.members.count]
      end
    end
  end
end
