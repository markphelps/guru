class Payment < ActiveRecord::Base
  scope :recent, -> { where('payment_date > ?', 90.days.ago).order('payment_date DESC') }

  after_create { |payment| payment.account.payment_made! payment.payment_amount }
  after_destroy { |payment| payment.account.payment_deleted! payment.payment_amount }

  validates_date :due_date, :payment_date
  validates :amount_due, :payment_amount, presence: true

  # credit, check, cash
  classy_enum_attr :payment_method, default: 'check'

  belongs_to :account

  def self.for_month(month = Date.current.month, year = Date.current.year)
    where('extract(month from payment_date) + 0 = ?', month).where('extract(year from payment_date) + 0 = ?', year).order('payment_date DESC')
  end
end
