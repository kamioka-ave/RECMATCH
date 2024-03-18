require 'rails_helper'

RSpec.describe Consultation, type: :model do
  let(:supporter) {create :supporter}
  let(:company) {create :company}
  let(:group_chat_category) {create :group_chat_category}
  let(:group_chat) {create :group_chat, category: group_chat_category}
  let!(:group_chat_member) {create :group_chat_member, group_chat: group_chat, member: company}
  let(:consultation) do
    create :consultation, group_chat_category_id: group_chat_category.id, company_id: company.id, supporter_id: supporter.id
  end
  subject{consultation}

  describe 'validations' do
    it { should validate_uniqueness_of(:supporter_id).scoped_to(:company_id, :group_chat_category_id) }
  end

  describe 'associations' do
    it { should belong_to(:supporter) }
    it { should belong_to(:company) }
    it { should belong_to(:group_chat_category).with_foreign_key(:group_chat_category_id) }
  end

  describe '.by_category' do
    let(:group_chat_category_different) {create :group_chat_category}
    let!(:consultation_different) do
      create :consultation, group_chat_category_id: group_chat_category_different.id, company_id: company.id, supporter_id: supporter.id
    end

    it "should return consultations" do
      expect(Consultation.by_category group_chat_category.id).to eq [consultation]
    end
  end
end
