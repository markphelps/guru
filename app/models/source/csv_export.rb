class Source::CsvExport
  def initialize(sources)
    @sources = sources
  end

  def filename
    'sources.csv'
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Name Members)
      @sources.each do |source|
        csv << [source.name, source.members.count]
      end
    end
  end
end
