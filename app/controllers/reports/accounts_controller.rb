module Reports
  class AccountsController < ApplicationController
    include ::CsvExportable
    before_filter :report

    def index
      @accounts = @report.accounts.page params[:page]
    end

    def export
      export_csv @report
    end

    private

    def report
      type = ['due', 'up_to_date', 'past_due', 'all'].delete params[:type]
      @report = Report::AccountReport.new(current_studio, type)
    end
  end
end
