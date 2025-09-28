FactoryBot.define do
  factory :authentication do
    provider { "google" }
    sequence(:uid) { |n| "uid#{n}" }
    
    # Don't automatically create a user association
    # Let the test explicitly create the user when needed
    user { nil }
    
    trait :with_user do
      association :user, :with_authentication
    end
    
    trait :with_password_user do
      association :user, :with_password
    end
  end
end