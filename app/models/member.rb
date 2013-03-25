class Member < ActiveRecord::Base
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  searchkick

  validates :first_name, :last_name, :membership_type, :membership_price, presence: true
  validates_date :birthday, allow_blank: true, on_or_before: -> { Date.current }
  validates_date :start_date, allow_blank: true
  validates_date :end_date, allow_blank: true, after: :start_date

  # annual, monthly, visit
  classy_enum_attr :membership_type, default: 'monthly'

  mount_uploader :image, ImageUploader

  belongs_to :studio
  belongs_to :level
  belongs_to :source

  has_one :account

  has_many :payments, through: :account, order: 'created_at DESC'
  has_many :visits, order: 'created_at DESC'
  has_many :notes, order: 'created_at DESC', class_name: Member::Note

  delegate :payment_due_date, :balance, to: :account, prefix: true
  delegate :default_payment_amount, to: :account, prefix: false

  def name
    [first_name, last_name].join ' '
  end

  def address?
    ![street_address, city, state, zip].compact.reject { |a| a.empty? }.empty?
  end

  def account?
    account.present?
  end

  def self.recent(since = 15.days.ago)
    where('created_at > ?', since)
  end

  def self.birthdays(month = Date.current.month)
    where('extract(month from birthday) + 0 = ?', month)
  end
end
