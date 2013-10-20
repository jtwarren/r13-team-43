FactoryGirl.define do
  factory :challenge do
    association :creator, factory: :user
    sequence(:title) {|n| "Challenge Nr #{n}"}
    group
  end
end