class Report::PaymentReport < Report::YearlyReport
  include ActionView::Helpers::NumberHelper

  def payments
    start_date = Date.new(@year, @month, 1)
    end_date = start_date.next_month.at_beginning_of_month
    @studio.payments.select('MAX(payments.id), COUNT(*) AS payments_count, SUM(payment_amount) AS total, payments.account_id, MAX(DATE(payments.payment_date)) AS payment_date')
      .where(payment_date: start_date...end_date)
      .group('payments.account_id')
  end

  def name
    "#{month_name} Payments"
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(First\ Name Last\ Name Last\ Payment Payments Total)
      payments.each do |payment|
        csv << [payment.account.member.first_name, payment.account.member.last_name, payment.payment_date.strftime('%m/%d/%Y'), payment.payments_count, number_to_currency(payment.total,  unit: '')]
      end
    end
  end

  def filename
    "#{Date::ABBR_MONTHNAMES[@month].downcase}_payments.csv"
  end
end

