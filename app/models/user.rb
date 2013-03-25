class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, presence: true
  before_destroy :can_destroy?

  belongs_to :studio

  def name
    [first_name, last_name].join ' '
  end

  def can_destroy?
    (owner? || studio.users.count == 1) ? false : true
  end
end
