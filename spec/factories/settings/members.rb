require 'forgery'

FactoryGirl.define do
  factory :settings_member, :class => 'Settings::Member' do
    default_payment_due_day_enabled { Forgery(:basic).boolean }
    default_payment_due_day { Forgery(:basic).number }

    association :studio
  end
end
