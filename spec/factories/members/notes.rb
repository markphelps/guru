# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member_note, class: Member::Note do
    body { Forgery(:basic).text }
    association :member
  end
end
