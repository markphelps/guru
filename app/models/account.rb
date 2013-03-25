class Account < ActiveRecord::Base
  scope :due, -> { where(state: 0) }
  scope :up_to_date, -> { where(state: 1) }
  scope :past_due, -> { where(state: 2) }
  scope :due_today, -> { where("payment_due_date >= ? AND balance > 0 AND accounts.state != 0", Date.current) }
  scope :past_due_today, -> { where("payment_due_date < ? AND balance > 0 AND accounts.state != 2", Date.current) }

  validates :balance, presence: :true
  validates_date :payment_due_date

  belongs_to :member

  has_many :payments, order: 'created_at DESC'

  state_machine initial: :up_to_date do
    state :due, value: 0
    state :up_to_date, value: 1
    state :past_due, value: 2

    event :is_up_to_date do
      transition [:due, :past_due] => :up_to_date
    end

    event :payment_is_due do
      transition [:up_to_date, :past_due] => :due
    end

    event :payment_is_past_due do
      transition [:up_to_date, :due] => :past_due
    end
  end

  def now_up_to_date?
    zero_balance? && !up_to_date?
  end

  def now_due?
    owes? && !due_date_passed? && !due?
  end

  def now_past_due?
    owes? && due_date_passed? && !past_due?
  end

  def update_status
    if now_up_to_date?
      is_up_to_date!
    elsif now_due?
      payment_is_due!
    elsif now_past_due?
      payment_is_past_due!
    end
  end

  def status
    case state
    when 0 then 'Due'
    when 1 then 'Up To Date'
    when 2 then 'Past Due'
    end
  end

  def color
    case state
    when 0 then '#9c9c9c'
    when 1 then '#41cac0'
    when 2 then '#ff6c60'
    end
  end

  def payment_made!(amount)
    self.balance -= amount
    update_status
    save
  end

  def payment_deleted!(amount)
    self.balance += amount
    update_status
    save
  end

  def owes?
    balance > 0
  end

  def zero_balance?
    !owes?
  end

  def due_date_passed?
    payment_due_date < Date.current
  end

  def last_payment
    payments.order('created_at DESC').first
  end

  def next_payment_due_date
    if member.membership_type.weekly?
      payment_due_date + 7
    elsif member.membership_type.monthly?
      payment_due_date >> 1
    elsif member.membership_type.annual?
      payment_due_date >> 12
    else
      payment_due_date
    end
  end

  def default_payment_amount
    return balance if owes?
    0
  end

  def self.default_payment_due_date(studio)
    payment_due_date = Date.current
    if studio.member_settings? && studio.member_settings.default_payment_due_day_enabled?
      payment_due_date = payment_due_date.change(day: studio.member_settings.current_month_payment_due_day)
    end
    payment_due_date
  end
end
