require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:authentications).dependent(:destroy) }
  end

  describe '#password_required?' do
    context 'when user has no authentications' do
      let(:user) { build(:user, :with_password) }

      it 'requires password' do
        expect(user.password_required?).to be true
      end
    end

    context 'when user has authentications' do
      let(:user) { create(:user, :with_authentication) }

      it 'does not require password' do
        expect(user.password_required?).to be false
      end
    end
  end
end
