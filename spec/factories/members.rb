require 'forgery'

FactoryGirl.define do
  factory :member do
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    email { Forgery(:internet).email_address }
    phone { Forgery(:address).phone }
    city { Forgery(:address).city }
    state { Forgery(:address).state }
    street_address { Forgery(:address).street_address }
    zip { Forgery(:address).zip }
    birthday Date.current
    active true
    start_date Date.current
    end_date Date.current >> 12
    membership_type :monthly
    membership_price { Forgery(:monetary).money }

    association :studio
  end

  factory :invalid_member, parent: :member do
    first_name nil
  end
end
