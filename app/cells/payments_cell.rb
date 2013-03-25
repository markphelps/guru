class PaymentsCell < Cell::Rails
  def monthly_revenue(studio)
    @revenue = studio.payments.for_month.sum(:payment_amount)
    render
  end
end
