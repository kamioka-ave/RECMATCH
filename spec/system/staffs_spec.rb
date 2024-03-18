# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat', type: :system do
  describe "Group chat page" do
    let!(:company) { create(:company_user) }
    let!(:supporter_user) { create(:supporter_user) }
    let!(:staff_user) { create(:staff_user) }
    let!(:group_chat) { create(:group_chat) }

    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporter_user.supporter) }
    let!(:group_chat_member3){ create(:group_chat_member, group_chat: group_chat, member: staff_user.staff) }
    let!(:message){ create(:message, group_chat: group_chat, sender: company.company) }

    context 'When company user is on support page' do
      it 'they can see a list of support categories' do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: staff_user.email
        fill_in 'user_password', with: staff_user.password
        click_button 'ログイン'

        # List of categories
        visit mypage_staff_path
        expect(page).to have_content('サポーターに相談')
        expect(page).to have_content(group_chat.category.name)
      end
    end
  end
end
