# coding: utf-8
require 'rails_helper'

RSpec.describe 'Staffs', type: :system do
  let!(:company) { create(:company) }
  before(:each) do
    admin = create(:admin, email: "email_admin@example.com")
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button 'ログイン'
  end
  after(:each) do
    DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
  end

  describe 'Show staffs of company' do
    context 'When visiting staffs of company page' do
      xit 'show list staffs' do
        (1..150).each do |i|
          create(:staff, company: company, user: create(:staff_user))
        end
        visit admin_company_staffs_path(company_id: company)
        expect(page).to have_css ".pagination li", count: 4
      end
    end
  end

  describe 'Create staff of company' do
    context 'when create staff fail' do
      xit 'should return message errors' do
        visit new_admin_company_staff_path(company_id: company)
        fill_in 'user_email', with: "test"
        click_button '登録する'
        expect(page).to have_content 'エラーがあります。確認してください。'
      end
    end

    context 'when create staff success' do
      xit 'should return message success' do
        visit new_admin_company_staff_path(company_id: company)
        fill_in 'user_email', with: 'test@gmail.com'
        fill_in 'user_password', with: '12345678'
        fill_in 'user_password_confirmation', with: '12345678'
        fill_in 'user_staff_attributes_last_name', with: 'name'
        fill_in 'user_staff_attributes_first_name', with: 'test'
        fill_in 'user_staff_attributes_last_name_kana', with: 'カ'
        fill_in 'user_staff_attributes_first_name_kana', with: 'サン'
        click_button '登録する'
        expect(page).to have_content 'メール送信が完了しました'
      end
    end
  end
end
