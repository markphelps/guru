require 'forgery'

FactoryGirl.define do
  factory :klass do
    day_of_week { Forgery(:date).day_of_week }
    class_time { Time.zone.now }
    name { Forgery(:lorem_ipsum).characters }
    recurring { Forgery(:basic).boolean }

    association :studio
  end

  factory :invalid_klass, parent: :klass do
    name nil
  end
end
