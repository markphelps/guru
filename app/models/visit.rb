class Visit < ActiveRecord::Base
  validates_date :visit_date

  belongs_to :klass, inverse_of: :visits
  belongs_to :member

  def self.recent(since = 15.days.ago)
    where('visit_date > ?', since)
  end
end
