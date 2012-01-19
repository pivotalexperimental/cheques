FactoryGirl.define do

  #Organizations

  factory :organization do
    name 'Evil Overlords'
  end

  #Users

  factory :user do
    first_name "Billy"
    last_name "The Kid"
    sequence(:email) {|n| "user#{n}@example.com" }
    password "foobar"
    association :organization
  end

  factory :rival, class: User do
    first_name "Willy"
    last_name "Naughty"
    sequence(:email) {|n| "willy#{n}@rivals.com" }
    password "foobar"
    association :organization, name: "Rival Organization"
  end

  #Runs

  factory :cheque_run do
    association :owner, factory: :user
  end

  #Cheques

  factory :cheque do
    payee 'Wei'
    description 'bonus!'
    date 1.day.ago
    amount 2_000_000
    association :cheque_run
  end

end