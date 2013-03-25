class Settings::Member < ActiveRecord::Base
  self.table_name = "settings_members"

  validates :default_payment_due_day, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }

  belongs_to :studio

  def current_month_payment_due_day
    last_day_of_month = Date.current.end_of_month.day
    return last_day_of_month < default_payment_due_day ? last_day_of_month : default_payment_due_day
  end
end
