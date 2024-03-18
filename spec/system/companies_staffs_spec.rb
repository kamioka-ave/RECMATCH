# coding: utf-8
require 'rails_helper'
 RSpec.describe 'Companies staffs', type: :system do
  describe 'Companies staffs page' do
    let!(:company_user) { create(:company_user) }
    let!(:staff) { create(:staff, user: create(:staff_user), company: company_user.company) }
    context 'when company have staffs' do
      before do
        company_user.company.update(agree_use_group_chat: true)
      end
       it 'show list staffs' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'
        visit mypage_company_staffs_path(company_user.company)
        expect(page).to have_content(staff.email)
      end
    end

    context 'when invite new staff' do
      it 'show new staff in list' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        visit new_mypage_company_staff_path
        fill_in 'user_email', with: 'test1@gmail.com'
        fill_in 'user_staff_attributes_last_name', with: '姓'
        fill_in 'user_staff_attributes_first_name', with: '名'
        fill_in 'user_staff_attributes_first_name_kana', with: 'セイ'
        fill_in 'user_staff_attributes_last_name_kana', with: 'メイ'
        fill_in 'user_password', with: 'pasword123'
        fill_in 'user_password_confirmation', with: 'pasword123'
        click_button '登録する'

        visit mypage_company_staffs_path(company_user.company)
        expect(page).to have_content('test1@gmail.com')
      end
    end
  end
end
