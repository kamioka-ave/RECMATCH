require 'rails_helper'

RSpec.describe Supporter, type: :model do
  describe 'associations' do
    it { should have_many(:group_chat_categories).through(:consultations) }
  end

  describe '#group_chats_with_company' do
    let!(:company) { create :company }
    let!(:supporter) { create :supporter }
    let!(:group_chat_category) { create :group_chat_category }

    it "should return [] when not added to company" do
      expect(supporter.group_chats_with_company(company.id)).to eq []
    end

    it "should return array group_chat_category when added to company" do
      create :consultation, group_chat_category_id: group_chat_category.id, company_id: company.id, supporter_id: supporter.id

      expect(supporter.group_chats_with_company(company.id)).to eq [group_chat_category]
    end
  end

  describe '#unread_messages_count' do
    subject { supporter_user.supporter.unread_messages_count.first.unread_messages_count }

    let(:company_user) { create :company_user }
    let(:supporter_user) { create :supporter_user }
    let!(:group_chat) do
      create :consultation, company: company_user.company, supporter: supporter_user.supporter
      create(:group_chat_member, member: company_user.company).group_chat
    end
    let!(:supporter_member) { create(:group_chat_member, member: supporter_user.supporter, group_chat: group_chat) }

    context "when company group chat have not message yet" do
      it "should return []" do
        is_expected.to eq 0
      end
    end

    context "is new member when company group chat have message" do
      it "should return 0 when supporter has 1 message" do
        create :message, group_chat: group_chat, sender: company_user.company
        is_expected.to eq 0
      end

      it "should return 0 when supporter has 5 message" do
        create_list :message, 5, group_chat: group_chat, sender: company_user.company
        is_expected.to eq 0
      end
    end

    context "when company group chat have message" do
      before { supporter_member.update_attributes(last_read: 1.day.ago) }
      it "should return 1 when supporter has 1 unread message" do
        create :message, group_chat: group_chat, sender: company_user.company
        is_expected.to eq 1
      end

      it "should return 2 when supporter has 5 unread message" do
        create_list :message, 5, group_chat: group_chat, sender: company_user.company
        is_expected.to eq 5
      end
    end

    context "when suppoter has read a part of messages" do
      before { create_list :message, 4, group_chat: group_chat, sender: company_user.company, updated_at: 1.day.from_now }
      it "should return 4 when supporter has read 1 message on total 5 messages" do
        create :message, group_chat: group_chat, sender: company_user.company, updated_at: 1.day.ago
        supporter_member.update_attributes(last_read: Time.now)
        is_expected.to eq 4
      end

      it "should return 0 when supporter has read all messages" do
        supporter_member.update_attributes(last_read: 1.day.from_now)
        is_expected.to eq 0
      end
    end
  end
end
