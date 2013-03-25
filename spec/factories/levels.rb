require 'forgery'

FactoryGirl.define do
  factory :level do
    name { Forgery(:basic).text }
    color { Forgery(:basic).hex_color }

    association :studio
  end
end
