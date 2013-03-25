require 'forgery'

FactoryGirl.define do
  factory :payment do
    payment_date Date.current
    due_date Date.current
    payment_amount { Forgery(:monetary).money }
    amount_due { Forgery(:monetary).money }
    payment_method :check
    association :account
  end

  factory :invalid_payment, parent: :payment do
    payment_date nil
  end
end
