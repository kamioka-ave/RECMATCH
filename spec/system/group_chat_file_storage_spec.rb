# coding: utf-8
require 'rails_helper'

RSpec.describe 'Group Chat File Storage', type: :system do
  describe "Group Chat File Storage" do
    let(:company_user) { create(:company_user) }
    let!(:category_1) { create(:group_chat_category, name: 'Category 1') }
    let!(:group_chat){ create(:group_chat, category: category_1) }
    let!(:group_chat_member){ create(:group_chat_member, group_chat: group_chat, member: company_user.company) }

    context 'when group chat not have attachment' do
      before{ company_user.company.update(agree_use_group_chat: true) }

      it 'does not contain attachment' do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        visit mypage_company_group_chat_category_path(category_1)

        click_button 'btn-file-storage'
        expect(page).not_to have_content('1.jpg')
      end
    end

    context 'when group chat have attachment' do
      before do
        company_user.company.update(agree_use_group_chat: true)
        create(:message, group_chat: group_chat , sender: company_user.company,
          attachment: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', '1.jpg'), 'image/jpg'))
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      it 'contain attachment' do
        # Login
        visit new_user_session_path
        fill_in 'メールアドレス', with: company_user.email
        fill_in 'user_password', with: company_user.password
        click_button 'ログイン'

        visit mypage_company_group_chat_category_path(category_1)

        click_button 'btn-file-storage'
        expect(page).to have_content('1.jpg')
      end
    end
  end
end
