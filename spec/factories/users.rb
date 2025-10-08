FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    name { "Test User" }

    trait :with_password do
      password { "password123" }
      password_confirmation { "password123" }
    end

    trait :with_authentication do
      after(:build) do |user|
        user.authentications.build(provider: 'google', uid: 'test_uid')
      end
    end
  end
end
