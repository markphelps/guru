module Reports
  class PaymentsController < ApplicationController
    include ::CsvExportable
    before_filter :report

    def index
      @payments = @report.payments.page params[:page]
    end

    def export
      export_csv @report
    end

    private

    def report
      @report = Report::PaymentReport.new(current_studio, params[:month], params[:year])
    end
  end
end
