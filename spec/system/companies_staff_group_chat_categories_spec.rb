# coding: utf-8
require 'rails_helper'
 RSpec.describe 'Companies staff group chat categories', type: :system do
  describe 'Companies staffs group chat categories' do
    let!(:company_user) { create(:company_user) }
    let!(:category_1) { create(:group_chat_category, name: 'Category 1') }
    let!(:group_chat){ create(:group_chat, category: category_1) }
    let!(:group_chat_member){ create(:group_chat_member, group_chat: group_chat, member: company_user.company) }
    let!(:staff) { create(:staff, user: create(:staff_user), company: company_user.company) }

    context 'when company have staffs' do
      before do
        company_user.company.update(agree_use_group_chat: true)
        create(:staff_group_chat_category, staff: staff, group_chat_category: category_1)
      end
       it 'show list categories of staff' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        visit mypage_company_staff_group_chat_categories_path(staff, company_user.company)
        expect(page).to have_content('Category 1')
      end
    end
  end
end
