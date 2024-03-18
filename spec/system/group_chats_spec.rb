# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat', type: :system do
  describe "Group chat page" do
    let(:company_user) { FactoryBot.create(:company_user) }
    let(:supporter_user) { FactoryBot.create(:supporter_user) }
    let!(:category_1) { FactoryBot.create(:group_chat_category, name: 'Category 1') }
    let!(:category_2) { FactoryBot.create(:group_chat_category, name: 'Category 2') }
    let!(:group_chat_1){ create(:group_chat, category: category_1) }
    let!(:group_chat_2){ create(:group_chat, category: category_2) }
    let!(:group_chat_member_1){ create(:group_chat_member, group_chat: group_chat_1, member: company_user.company) }
    let!(:group_chat_member_2){ create(:group_chat_member, group_chat: group_chat_2, member: company_user.company) }

    context 'When company user is on support page' do
      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      it 'they can see a list of support categories', retry: 3 do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        # List of categories
        visit mypage_company_group_chat_categories_path(company_user.company)
        expect(page).to have_content('サポーターに相談')
        expect(page).to have_content(category_1.name)
        expect(page).to have_content(category_2.name)
      end

      xit 'they can visit a group chat and chat' do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        category_1.supporters << supporter_user.supporter

        Capybara.using_session("Supporter 1's session") do
          # Login
          visit new_user_session_path
          fill_in 'メールアドレス', with: supporter_user.email
          fill_in 'user_password', with: supporter_user.password
          click_button 'ログイン'

          visit mypage_supporter_companies_path
          expect(page).not_to have_content(company_user.company.name)
        end

        visit new_user_session_path

        visit mypage_company_group_chat_category_path(category_1)
        expect(page).to have_content(category_1.name)
        fill_in 'メッセージを入力', with: 'abc'
        click_button '送信'
        expect(page).to have_content('abc')

        visit mypage_company_group_chat_category_path(category_2)
        expect(page).to have_content(category_2.name)
        expect(page).not_to have_content('abc')

        visit mypage_company_group_chat_category_path(category_1)
        expect(page).to have_content('abc')

        Capybara.using_session("Supporter 1's session 2") do
          # Login
          visit new_user_session_path
          fill_in 'メールアドレス', with: supporter_user.email
          fill_in 'user_password', with: supporter_user.password
          click_button 'ログイン'

          visit mypage_supporter_companies_path
          expect(page).to have_content(company_user.company.name)

          visit mypage_supporter_company_path(company_user.company)
          expect(page).to have_content(category_1.name)
          expect(page).not_to have_content(category_2.name)

          visit mypage_supporter_company_group_chat_category_path(company_user.company, category_1)
          expect(page).to have_content('abc')
          fill_in 'メッセージを入力', with: 'xyz'
          click_button '送信'
        end

        expect(page).to have_content('xyz')

        fill_in 'メッセージを入力', with: 'qwe'
        click_button '送信'
        expect(page).to have_content('qwe')
      end
    end
  end
end
