FactoryGirl.define do
  factory :organization do
    name 'Evil Overlords'
  end

  factory :user do
    first_name "Billy"
    last_name "The Kid"
    sequence(:email) {|n| "user#{n}@example.com" }
    password "foobar"
    association :organization
  end
end