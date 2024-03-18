# coding: utf-8
require 'rails_helper'

RSpec.describe 'Staff group chat categories', type: :system do
  let!(:company_user) { create(:company_user) }
  let!(:category_1) { create(:group_chat_category, name: 'Category 1') }
  let!(:group_chat){ create(:group_chat, category: category_1) }
  let!(:group_chat_member){ create(:group_chat_member, group_chat: group_chat, member: company_user.company) }
  let!(:staff) { create(:staff, user: create(:staff_user), company: company_user.company) }

  before(:each) do
    admin = create(:admin, email: "email_admin@example.com")
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button 'ログイン'
  end

  context 'when staff belong to category' do
    before { create(:staff_group_chat_category, staff: staff, group_chat_category: category_1) }

    it 'show list categories of staff' do
      visit admin_company_staff_group_chat_categories_path(company_user.company, staff)
      expect(page).to have_content('Category 1')
    end
  end
end
