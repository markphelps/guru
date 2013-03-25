class Payment::CsvExport
  include ActionView::Helpers::NumberHelper

  def initialize(member)
    @member = member
  end

  def filename
    "#{@member.name}_payments.csv"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(Payment\ Date Amount\ Paid Due\ Date Amount\ Due Method)
      @member.payments.each do |payment|
        csv << [payment.payment_date.strftime('%m/%d/%Y'), number_to_currency(payment.payment_amount,  unit: ''), payment.due_date.strftime('%m/%d/%Y'), number_to_currency(payment.amount_due,  unit: ''), payment.payment_method]
      end
    end
  end
end
