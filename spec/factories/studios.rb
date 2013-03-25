require 'forgery'

FactoryGirl.define do
  factory :studio do
    city { Forgery(:address).city }
    email { Forgery(:internet).email_address }
    name { Forgery(:name).company_name }
    phone { Forgery(:address).phone }
    state { Forgery(:address).state }
    street_address { Forgery(:address).street_address }
    zip { Forgery(:address).zip }
    time_zone { Time.zone.name }
  end

  factory :invalid_studio, parent: :studio do
    name nil
  end
end
