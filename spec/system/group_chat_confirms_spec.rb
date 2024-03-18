# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat Confirm', type: :system do
  describe "Group chat confirm page" do
    let(:company) { FactoryBot.create(:company_user) }
    let!(:supporters) { create_list(:supporter_user, 4) }
    let!(:group_chat){ create(:group_chat) }
    let!(:group_chat_member1){ create(:group_chat_member, group_chat: group_chat, member: company.company) }
    let!(:group_chat_member2){ create(:group_chat_member, group_chat: group_chat, member: supporters.first.supporter) }

    context 'First visit group chat categories page' do
      before{ company.company.update(agree_use_group_chat: false) }

      it 'redirect to confirm group chat page' do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company.email
        fill_in 'user_password', with: company.password
        click_button 'ログイン'

        visit mypage_company_group_chat_category_path(company.company)
        expect(page.current_path).to eq mypage_company_group_chat_confirm_path
      end
    end

    context 'Confirm term of use and redirect to group chat categories page' do
      before{ company.company.update(agree_use_group_chat: false) }

      it 'redirect to confirm group chat page', js: true do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company.email
        fill_in 'user_password', with: company.password
        click_button 'ログイン'

        visit mypage_company_group_chat_category_path(company.company)
        page.find(:xpath, "//a[@href='/pdfs/term_of_use.pdf']").click
        expect(page).to have_content("確認済")
        page.find(:css, "input[type='checkbox']", visible: false).set(true)
        click_button("同意して次の画面へ")
        expect(page.current_path).to eq mypage_company_group_chat_categories_path
      end
    end

    context 'Diagree term of use' do
      before{ company.company.update(agree_use_group_chat: false) }

      it 'redirect to confirm group chat page', js: true do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company.email
        fill_in 'user_password', with: company.password
        click_button 'ログイン'

        visit mypage_company_group_chat_category_path(company.company)
        page.find(:xpath, "//a[@href='/pdfs/term_of_use.pdf']").click
        expect(page).to have_content("確認済")
        click_button("同意して次の画面へ")
        expect(page).to have_content("ご利用規約の確認および同意事項")
      end
    end

    context 'Company agreed term of use' do

      it 'redirect to confirm group chat page', js: true do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company.email
        fill_in 'user_password', with: company.password
        click_button 'ログイン'
        visit mypage_company_group_chat_categories_path
        expect(page.current_path).to eq mypage_company_group_chat_categories_path
      end
    end
  end
end
