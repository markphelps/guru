require 'forgery'

FactoryGirl.define do
  factory :user do
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    email { Forgery(:internet).email_address }
    password { Forgery(:basic).password(at_least: 8) }
    association :studio
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
