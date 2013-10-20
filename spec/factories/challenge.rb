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

    trait :completed do
      after(:create) do |challenge|
        completer = FactoryGirl.create(:user, groups: [challenge.group])

        challenge.complete(completer)
      end
    end

    factory :challenge_active, traits: [:active]
    factory :challenge_completed, traits: [:active, :completed]
  end
end