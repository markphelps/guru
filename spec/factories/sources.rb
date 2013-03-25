# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :source do
    name { Forgery(:basic).text }

    association :studio
  end
end
