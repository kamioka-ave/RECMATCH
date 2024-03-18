require 'rails_helper'

RSpec.describe 'Companies', type: :system do
  describe '企業登録' do
    let(:user_email) { 'test@example.com' }
    let(:user_password) { 'registration_test_password' }

    context '企業登録を行った場合' do
      # Include email_spec modules here, not in rails_helper because they
      # conflict with the capybara-email#open_email method which lets us
      # call current_email.click_link below.
      # Re: https://github.com/dockyard/capybara-email/issues/34#issuecomment-49528389
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        visit new_user_registration_path(as: 'company')
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（企業）').click
        click_button '登録'
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      # open the most recent email sent to user_email
      subject { open_email(user_email) }

      it 'メールが正しく配信されること', retry: 3 do
        expect(subject).to deliver_to(user_email)
        expect(subject).to have_body_text(/このたびはRECMATCHにご登録をしていただき誠にありがとうございます。/)
      end
    end

    context '登録確認リンクを訪れた場合' do
      before(:each) do
        visit new_user_registration_path(as: 'company')
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（企業）').click
        click_button '登録'
        user = User.find_for_authentication(email: user_email)
        visit user_confirmation_path(confirmation_token: user.confirmation_token)
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      it '登録確認済みになること', retry: 3 do
        user = User.find_for_authentication(email: user_email)
        expect(user).to be_confirmed
      end
    end

    context '企業申請フローを完了した場合' do
      before(:each) do
        FactoryBot.create(:admin_recmatch_sales_department)

        visit new_user_registration_path(as: 'company')
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（企業）').click
        click_button '登録'
        user = User.find_for_authentication(email: user_email)
        visit user_confirmation_path(confirmation_token: user.confirmation_token)

        # STEP1 確認および同意事項
        click_link '1. 利用規約（企業）'
        click_link '2. 企業情報等取扱約款'
        click_link '3. プライバシーポリシー'
        find('label[for=company_agreement_agreement]').click
        find('label[for=company_agreement_terms10_agreed]').click
        click_button '同意して次の画面へ'

        # STEP2 企業基本情報
        fill_in('company_name', with: '株式会社メルカリ')
        fill_in('company_name_kana', with: 'カブシキガイシャメルカリ')
        fill_in('company_president_last_name', with: '山田')
        fill_in('company_president_first_name', with: '太郎')
        fill_in('company_president_last_name_kana', with: 'ヤマダ')
        fill_in('company_president_first_name_kana', with: 'タロウ')
        fill_in('company_website', with: 'なし')
        select('1980', from: 'company_president_birth_on_1i')
        click_button '次へ'

        # STEP3 企業詳細情報
        click_button 'スキップして次へ'

        # STEP4 入力内容の確認
        click_button '完了'
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      it '登録完了画面に遷移すること' do
        expect(page).to have_content('ご登録ありがとうございます')
      end
    end
  end
end