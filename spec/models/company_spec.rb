require 'rails_helper'

RSpec.describe Company, type: :model do
  describe ".count_message_on" do
    subject { company_user.company }

    let(:company_user) { create :company_user }
    let(:supporter_user) { create :supporter_user }
    let(:supporter) { supporter_user.supporter }
    let!(:group_chat) do
      create :consultation, company: subject, supporter: supporter
      group_chat = create(:group_chat_member, member: supporter).group_chat
      create :group_chat_member, member: subject, group_chat: group_chat
      group_chat
    end

    context "when supporter has not chat with company yet" do
      it "should count 0 message on company" do
        company = Company.count_messages_on(supporter).first
        is_expected.to eq company
        expect(company.message_count).to eq 0
      end
    end

    context "when supporter has chat with company" do
      it "should count 1 message on company" do
        create :message, group_chat: group_chat, sender: supporter
        company = Company.count_messages_on(supporter).first
        is_expected.to eq company
        expect(company.message_count).to eq 1
      end

      it "should count 5 messages on company" do
        create_list :message, 5, group_chat: group_chat, sender: supporter
        company = Company.count_messages_on(supporter).first
        is_expected.to eq company
        expect(company.message_count).to eq 5
      end
    end
  end
end
