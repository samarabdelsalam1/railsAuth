# spec/services/users/omniauth_service_spec.rb
require 'rails_helper'

RSpec.describe Users::OmniauthService do
  let(:auth) do
    OmniAuth::AuthHash.new(
      provider: 'google_oauth2',
      uid: '12345',
      info: { email: 'test@example.com', name: 'Test User' }
    )
  end

  it "creates a new user if none exists" do
    user = described_class.new(auth).call
    expect(user).to be_persisted
    expect(user.email).to eq('test@example.com')
  end

  it "links a new authentication to existing user" do
    existing_user = create(:user, :with_password, email: 'test@example.com')
    user = described_class.new(auth).call
    expect(user).to eq(existing_user)
    expect(user.authentications.count).to eq(1)
  end
end
