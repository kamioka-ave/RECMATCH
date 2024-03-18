# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat Category Companies', type: :system do
  describe 'Create group chat category' do
    context 'When visiting a supporter details page' do
      before(:each) do
        admin = FactoryBot.create(:admin, email: "email_admin@example.com")

        visit new_admin_session_path
        fill_in 'メールアドレス', with: admin.email
        fill_in 'パスワード', with: admin.password
        click_button 'ログイン'
      end

      xit 'Show detail of category' do
        supporter = create :supporter
        group_chat_category = create :group_chat_category
        company = create :company
        visit admin_group_chat_category_company_path(group_chat_category, company)
        expect(page).to have_content group_chat_category.name
        expect(page).to have_content supporter.name
      end
    end
  end
end
