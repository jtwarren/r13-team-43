FactoryGirl.define do
  factory :challenge do
    association :owner, factory: :user
    sequence(:title) {|n| "Challenge Nr #{n}"}
    group
  end
end