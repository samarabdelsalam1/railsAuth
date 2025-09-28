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

require 'rails_helper'

RSpec.describe Authentication, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    # Create the subject with a user that has password or authentication
    subject { build(:authentication, user: create(:user, :with_password)) }

    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:uid) }
    it { should validate_uniqueness_of(:uid).scoped_to(:provider) }
  end

  describe 'uniqueness constraint' do
    let(:user) { create(:user, :with_password) }
    let!(:auth1) { create(:authentication, provider: 'google', uid: '123', user: user) }

    it 'does not allow duplicate provider/uid pairs' do
      duplicate = build(:authentication, provider: 'google', uid: '123', user: user)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:uid]).to include('has already been taken')
    end

    it 'allows same uid with different provider' do
      other = build(:authentication, provider: 'github', uid: '123', user: user)
      expect(other).to be_valid
    end

    it 'does not allow same uid and provider for different users' do
      other_user = create(:user, :with_password)
      other = build(:authentication, provider: 'google', uid: '123', user: other_user)
      expect(other).not_to be_valid
      expect(other.errors[:uid]).to include('has already been taken')
    end
  end
end
