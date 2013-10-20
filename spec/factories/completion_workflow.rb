FactoryGirl.define do
  factory :completion_workflow do
    association :creator, factory: :user
  end
end