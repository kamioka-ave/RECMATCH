# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat Categories', type: :system do
  describe 'Create group chat category' do
    context 'When visiting a supporter details page' do
      before(:each) do
        admin = FactoryBot.create(:admin, email: "email_admin@example.com")

        visit new_admin_session_path
        fill_in 'メールアドレス', with: admin.email
        fill_in 'パスワード', with: admin.password
        click_button 'ログイン'
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      xit 'Create category' do
        FactoryBot.create_list(:group_chat_category, 60)
        visit admin_group_chat_categories_path
        expect(page).to have_css ".pagination li", count: 4
      end

      xit 'Show detail of category' do
        supporter = FactoryBot.create :supporter
        group_chat_category = FactoryBot.create :group_chat_category, supporters: [supporter]
        visit admin_group_chat_category_path(group_chat_category)
        expect(page).to have_content group_chat_category.name
        expect(page).to have_content group_chat_category.ranking
      end
    end
  end
end
