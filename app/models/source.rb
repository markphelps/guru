class Source < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { scope: :studio_id }

  belongs_to :studio
  has_many :members

  scope :top_ten, joins('LEFT JOIN members ON members.source_id = sources.id').
      select('sources.*, count(members.id) AS members_count').
      group('sources.id').
      order('members_count DESC').
      limit(10)
end
