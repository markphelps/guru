class Level < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :studio_id }
  validates :color, format: /\A#(\h{6}|\h{3})\z/

  belongs_to :studio
  has_many :members

  scope :top_ten, joins('LEFT JOIN members ON members.level_id = levels.id').
    select('levels.*, count(members.id) AS members_count').
    group('levels.id').
    order('members_count DESC').
    limit(10)
end
