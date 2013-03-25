module Reports
  module Members
    class BirthdaysController < ApplicationController
      include ::CsvExportable
      before_filter :report

      def index
        @members = @report.members.order('birthday ASC').page params[:page]
      end

      def export
        export_csv @report
      end

      private

      def report
        @report = Report::Member::BirthdayReport.new(current_studio, params[:month])
      end
    end
  end
end
