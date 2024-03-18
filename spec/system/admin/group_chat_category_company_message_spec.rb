# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat Category Company Messages', type: :system do
  describe 'Create group chat category' do
    let!(:company_user) { create(:company_user) }
    let!(:category) { create(:group_chat_category, name: 'Category 1') }
    let!(:group_chat){ create(:group_chat, category: category) }
    let!(:group_chat_member){ create(:group_chat_member, group_chat: group_chat, member: company_user.company) }

    context 'When visiting a supporter details page' do
      before(:each) do
        admin = FactoryBot.create(:admin, email: "email_admin@example.com")

        visit new_admin_session_path
        fill_in 'メールアドレス', with: admin.email
        fill_in 'パスワード', with: admin.password
        click_button 'ログイン'
      end

      it 'show empty messages list' do
        visit admin_group_chat_category_company_messages_path(category, company_user.company)
        expect(page).not_to have_selector :css, 'timeline'
      end

      it 'show messages list' do
        create(:message, group_chat: group_chat, body: 'message test 1', sender: company_user.company)
        create(:message, group_chat: group_chat, body: 'message test 2', sender: company_user.company)
        visit admin_group_chat_category_company_messages_path(category, company_user.company)
        expect(page).to have_content 'message test 1'
        expect(page).to have_content 'message test 2'
      end
    end
  end
end
