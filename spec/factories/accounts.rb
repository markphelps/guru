require 'forgery'

FactoryGirl.define do
  factory :account do
    balance { Forgery(:monetary).money }
    payment_due_date Date.current >> 1

    association :member
  end

  factory :due_account, parent: :account do
    state 0
  end

  factory :up_to_date_account, parent: :account do
    state 1
    balance 0
  end

  factory :past_due_account, parent: :due_account do
    state 2
    payment_due_date Date.current << 1
  end
end
