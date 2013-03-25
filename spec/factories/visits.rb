require 'forgery'

FactoryGirl.define do
  factory :visit do
    visit_date Date.current
    association :member
    association :klass
  end

  factory :invalid_visit, parent: :visit do
    visit_date nil
  end
end
