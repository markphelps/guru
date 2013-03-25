class Studio < ActiveRecord::Base
  validates :name, :email, presence: true
  validates_uniqueness_of :email
  validates_inclusion_of :time_zone, in: ActiveSupport::TimeZone.zones_map(&:name)

  has_many :users
  has_many :members
  has_many :klasses
  has_many :levels
  has_many :accounts, through: :members
  has_many :payments, through: :accounts
  has_many :visits, through: :members
  has_many :sources

  has_one :member_settings, class_name: 'Settings::Member'

  before_create :default_values

  def self.current_id=(id)
    Thread.current[:studio_id] = id
  end

  def self.current_id
    Thread.current[:studio_id]
  end

  def address?
    ![street_address, city, state, zip].compact.reject { |a| a.empty? }.empty?
  end

  def member_settings?
    !member_settings.nil?
  end

  private

  def default_values
    self.time_zone ||= 'Eastern Time (US & Canada)'
  end
end
