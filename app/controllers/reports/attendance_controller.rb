module Reports
  class AttendanceController < ApplicationController
    include ::CsvExportable
    before_filter :report

    def index
      @members = @report.members.page params[:page]
    end

    def export
      export_csv @report
    end

    private

    def report
      @report = Report::AttendanceReport.new(current_studio, params[:month], params[:year])
    end
  end
end
