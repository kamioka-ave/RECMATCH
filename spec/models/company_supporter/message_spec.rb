require 'rails_helper'

RSpec.describe CompanySupporter::Message, type: :model do
  context "validations" do
    it { should have_many(:members).through(:group_chat) }
  end

  context 'attachment message' do
    let(:company_user) { create(:company_user) }
    let!(:category) { create(:group_chat_category, name: 'Category 1') }
    let!(:group_chat){ create(:group_chat, category: category) }
    let!(:group_chat_member){ create(:group_chat_member, group_chat: group_chat, member: company_user.company) }
    let!(:attachment_message) { create(:message, group_chat: group_chat , sender: company_user.company,
      attachment: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '1.jpg'), 'image/jpg')) }
    let!(:text_message) { create(:message, group_chat: group_chat , sender: company_user.company) }

    it 'return to attachment message array' do
      expect(CompanySupporter::Message.attachment_message).to eq [attachment_message]
    end
  end

  describe 'member seen and unseen message' do
    let!(:company) { create(:company_user) }
    let!(:supporters) { create_list(:supporter_user, 4) }
    let!(:group_chat){ create(:group_chat) }

    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporters.first.supporter) }
    let!(:group_chat_member3){ create(:group_chat_member, group_chat: group_chat, member: supporters[1].supporter) }
    let!(:group_chat_member4){ create(:group_chat_member, group_chat: group_chat, member: supporters[2].supporter) }
    let!(:group_chat_member5){ create(:group_chat_member, group_chat: group_chat, member: supporters[3].supporter) }
    let!(:message){ create(:message, group_chat: group_chat, sender: company.company) }

    context 'nobody seen message' do
      let(:seen_member_method) { message.seen_members }
      let(:unseen_member_method) { message.unseen_members }

      it 'Number of seen member equal 0' do
        expect(seen_member_method.count).to eq 0
        expect(unseen_member_method.count).to eq message.members.count - 1
      end
    end

    context "One people seen message" do
      before{ group_chat_member2.update(last_read: Time.zone.now + 1.hours) }

      let(:seen_member_method) { message.seen_members }
      let(:unseen_member_method) { message.unseen_members }

      it 'Number of seen member equal 0' do
        expect(seen_member_method.count).to eq 1
        expect(unseen_member_method.count).to eq message.members.count - 2
      end
    end

    context "Two people seen message" do
      before{ group_chat_member2.update(last_read: Time.zone.now + 1.hours) }
      before{ group_chat_member3.update(last_read: Time.zone.now + 1.hours) }

      let(:seen_member_method) { message.seen_members }
      let(:unseen_member_method) { message.unseen_members }

      it 'Number of seen member equal 2' do
        expect(seen_member_method.count).to eq 2
        expect(unseen_member_method.count).to eq message.members.count - 3
      end
    end

    context "All people seen message" do
      before{ group_chat_member2.update(last_read: Time.zone.now + 1.hours) }
      before{ group_chat_member3.update(last_read: Time.zone.now + 1.hours) }
      before{ group_chat_member4.update(last_read: Time.zone.now + 1.hours) }
      before{ group_chat_member5.update(last_read: Time.zone.now + 1.hours) }

      let(:seen_member_method) { message.seen_members }
      let(:unseen_member_method) { message.unseen_members }

      it 'Number of seen member equal 4' do
        expect(seen_member_method.count).to eq 4
        expect(unseen_member_method.count).to eq 0
      end
    end
  end

  describe 'message' do
    let!(:company) { create(:company_user) }
    let!(:supporters) { create_list(:supporter_user, 4) }
    let!(:group_chat){ create(:group_chat) }
    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporters.first.supporter) }
    let!(:mention_message){ create(:message, body: "[TO id:#{supporters.first.supporter.id} type:Supporter]#{supporters.first.supporter.full_name}[/TO]",
      group_chat: group_chat, sender: company.company) }
    let!(:mention_message1){ create(:message, body: "This is content of message", group_chat: group_chat, sender: company.company) }

    context 'count number of messages' do
      it 'number of messages equal 2' do
        supporter = supporters.first.supporter
        expect(CompanySupporter::Message.messages(supporter.id, supporter.class.name).count).to eq 2
      end
    end
  end

  describe 'unread notification' do
    let!(:company) { create(:company_user) }
    let!(:supporters) { create_list(:supporter_user, 4) }
    let!(:group_chat){ create(:group_chat) }
    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporters.first.supporter) }
    let!(:mention_message){ create(:message, body: "[TO id:#{supporters.first.supporter.id} type:Supporter]#{supporters.first.supporter.full_name}[/TO]",
      group_chat: group_chat, sender: company.company) }
    let!(:mention_message1){ create(:message, body: "This is content of message", group_chat: group_chat, sender: company.company) }

    context 'when user still unread notification' do
      it 'number of notifications equal 2' do
        supporter = supporters.first.supporter
        expect(CompanySupporter::Message.unread_notifications(supporter.id, supporter.class.name).count).to eq 2
      end
    end

    context 'when user read new notification' do
      before{ group_chat_member2.update(last_read_notification: Time.zone.now + 1.hours) }

      it 'number of notifications equal 0' do
        supporter = supporters.first.supporter
        expect(CompanySupporter::Message.unread_notifications(supporter.id, supporter.class.name).count).to eq 0
      end
    end
  end

  describe 'mention messages' do
    let!(:company) { create(:company_user) }
    let!(:supporters) { create_list(:supporter_user, 4) }
    let!(:group_chat){ create(:group_chat) }
    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporters.first.supporter) }
    let!(:group_chat_member3){ create(:group_chat_member, group_chat: group_chat, member: supporters[1].supporter) }
    let!(:group_chat_member4){ create(:group_chat_member, group_chat: group_chat, member: supporters[2].supporter) }
    let!(:group_chat_member5){ create(:group_chat_member, group_chat: group_chat, member: supporters[3].supporter) }
    let(:mention_message){ create(:message, body: "[TO id:#{supporters.first.supporter.id} type:Supporter]#{supporters.first.supporter.full_name}[/TO]",
      group_chat: group_chat, sender: company.company) }
    let(:mention_message1){ create(:message,
      body: "[TO id:#{supporters.first.supporter.id} type:Supporter]#{supporters.first.supporter.full_name}[/TO][TO id:#{supporters[1].supporter.id} type:Supporter]#{supporters[1].supporter.full_name}[/TO]",
      group_chat: group_chat, sender: company.company) }
    context 'when first supporter dont have any mention messages' do
      it 'number of mention messages equal 0' do
        supporter = supporters.first.supporter
        expect(CompanySupporter::Message.mention_messages(supporter.id, supporter.class.name).count).to eq 0
      end
    end
    context 'when first supporter have one mention message unread' do
      it 'number of mention messages unread equal 1' do
        mention_message
        supporter = supporters.first.supporter
        expect(CompanySupporter::Message.mention_messages(supporters.first.supporter.id, supporter.class.name).count).to eq 1
      end
    end
    context 'when first supporter have two mention message unread and second supporter is one' do
      it 'number of mention messages unread of first supporter equal 2 and second is 1' do
        mention_message
        mention_message1
        supporter = supporters.first.supporter
        supporter1 = supporters[1].supporter
        expect(CompanySupporter::Message.mention_messages(supporter.id, supporter.class.name).count).to eq 2
        expect(CompanySupporter::Message.mention_messages(supporter1.id, supporter1.class.name).count).to eq 1
      end
    end
  end
end
