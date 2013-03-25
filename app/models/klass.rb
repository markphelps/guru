class Klass < ActiveRecord::Base
  scope :today, -> { where(day_of_week: Date::DAYNAMES[Date.current.wday]) }

  validates_time :class_time
  validates :name, presence: true, length: { maximum: 30 }
  validates_inclusion_of :day_of_week, in: Date::DAYNAMES

  belongs_to :studio
  has_many :visits

  def name_and_time
    "#{name} @ #{class_time.in_time_zone.strftime("%-l:%M %p")}"
  end

  def name_day_and_time
    "#{name} - #{day_of_week} @ #{class_time.in_time_zone.strftime("%-l:%M %p")}"
  end

  def self.for_day_of_week(day = Date.current.wday )
    day = Date::DAYNAMES[day.to_i].nil? ? Date.current.wday : day.to_i
    where(day_of_week: Date::DAYNAMES[day])
  end
end
