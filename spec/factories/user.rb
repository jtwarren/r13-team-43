FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test-user#{n}@inter.net" }

    trait :group do
      groups { FactoryGirl.create_list(:group, 1) }
    end

    trait :groups do
      groups { FactoryGirl.create_list(:group, 2) }
    end

    factory :user_with_group, traits: [:group]
    factory :user_with_groups, traits: [:groups]
  end
end