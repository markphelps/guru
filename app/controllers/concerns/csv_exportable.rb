module CsvExportable
  extend ActiveSupport::Concern
  include FilenameHelper

  protected

  def export_csv(report)
    send_data report.to_csv, type: 'text/csv', disposition: 'attachment', filename: timestamp_filename(report.filename)
  end
end
