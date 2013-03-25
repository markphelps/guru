module Reports
  class VisitsController < ApplicationController
    include ::CsvExportable
    before_filter :report

    def index
      @members = @report.members_visits.page params[:page]
    end
    
    def export
      export_csv @report
    end

    private

    def report
      @report = Report::VisitReport.new(current_studio, params[:month], params[:year])
    end
  end
end
