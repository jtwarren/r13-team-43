FactoryGirl.define do
  factory :challenge do
    association :creator, factory: :user
    sequence(:title) {|n| "Challenge Nr #{n}"}
    group

    trait :active do
      after(:create) do |challenge|
        challenge.vote(FactoryGirl.create(:user, groups: [challenge.group]))
      end
    end

    factory :challenge_active, traits: [:active]
  end
end