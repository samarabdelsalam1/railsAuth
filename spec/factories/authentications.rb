# == Schema Information
#
# Table name: authentications
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  provider   :string           not null
#  uid        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_authentications_on_provider_and_uid  (provider,uid) UNIQUE
#  index_authentications_on_user_id           (user_id)
#

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
