require 'rails_helper'

RSpec.describe UserToken, type: :model do
  describe 'associations' do
    it { should belong_to :user }
    it { should validate_uniqueness_of(:device_token).scoped_to(:user_id) }
  end

  describe '.not_expired' do
    let!(:user) { create :company_user }
    let!(:tokens) {create_list :user_token, 4, user: user }
    subject { UserToken.not_expired }

    it 'should return all when not expired' do
      is_expected.to eq tokens
    end

    it 'should return [] when all were expired' do
      user.user_tokens.update_all expires_at: 1.days.ago
      is_expected.to eq []
    end

    it 'should return tokens which not expired' do
      user.user_tokens.update_all expires_at: 1.days.ago
      new_tokens = create_list :user_token, 4, user: user, expires_at: 1.days.ago
      is_expected.to eq new_tokens
    end
  end
end
