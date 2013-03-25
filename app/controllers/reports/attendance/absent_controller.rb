module Reports
  module Attendance
    class AbsentController < ApplicationController
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
        @report = Report::Attendance::AbsentReport.new(current_studio, params[:month], params[:year])
      end
    end
  end
end
