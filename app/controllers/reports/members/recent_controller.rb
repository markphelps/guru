module Reports
  module Members
    class RecentController < ApplicationController
      include ::CsvExportable
      before_filter :report

      def index
        @members = @report.members.order('created_at DESC').page params[:page]
      end

      def export
        export_csv @report
      end

      private

      def report
        @report = Report::Member::RecentReport.new(current_studio)
      end
    end
  end
end
