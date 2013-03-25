class Member::Note < ActiveRecord::Base
  validates :body, presence: true

  belongs_to :member
end
