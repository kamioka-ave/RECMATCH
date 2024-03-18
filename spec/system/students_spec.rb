require 'rails_helper'

RSpec.describe 'Students', type: :system do
  describe '学生登録' do
    let(:user_email) { 'test@example.com' }
    let(:user_password) { 'registration_test_password' }

    context '学生登録を行った場合' do
      # Include email_spec modules here, not in rails_helper because they
      # conflict with the capybara-email#open_email method which lets us
      # call current_email.click_link below.
      # Re: https://github.com/dockyard/capybara-email/issues/34#issuecomment-49528389
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（学生）').click
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
        visit new_user_registration_path
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（学生）').click
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

      it 'ログインされていること', retry: 3 do
        expect(page).to have_content('手続きの流れ')
      end
    end

    context '学生申請フローを完了した場合' do
      before(:each) do
        FactoryBot.create(:bank)
        FactoryBot.create(:bank_branch)
        FactoryBot.create(:admin)

        visit new_user_registration_path
        fill_in 'メールアドレス', with: user_email
        fill_in 'user_password', with: user_password
        find('label', text: '利用規約（学生）').click
        click_button '登録'
        user = User.find_for_authentication(email: user_email)
        visit user_confirmation_path(confirmation_token: user.confirmation_token)

        # 学生登録の手続き
        click_link '確認および同意事項へ'

        # STEP1 確認および同意事項
        click_link '1. 利用規約（学生）'
        click_link '2. RECMATCH取引約款（学生）'
        click_link '3. 重要事項説明書'
        click_link '4. プライバシーポリシー'
        click_link '5. 電磁的方法による書面の交付に関する同意事項'
        find('label', text: '私は、「確認および同意事項」書面の内容に同意します。').click
        click_button '同意して次の画面へ'

        # STEP2 学生適合性確認
        select('給与所得', from: 'student_interview_income_resource')
        select('300万円-499万円', from: 'student_interview_income')
        select('300万円-499万円', from: 'student_interview_assets')
        choose 'student_interview_has_experience_true'
        find("input[name='exp_stock'][value='yes']").set(true)
        fill_in 'student_interview_exp_stock', with: 1
        select('余裕資金', from: 'student_interview_capital_character')
        select('高い投資リターンを得るため', from: 'student_interview_purpose')
        find('label', text: 'スポーツ').click
        find("input[name='student_interview[how_to_know]'][value='0']").set(true)
        click_button '次へ'

        # STEP3 学生申請書
        fill_in('student_last_name', with: '山田')
        fill_in('student_first_name', with: '太郎')
        fill_in('student_last_name_kana', with: 'ヤマダ')
        fill_in('student_first_name_kana', with: 'タロウ')
        choose('student_gender_0')
        select('1980', from: 'student_birth_on_1i')
        fill_in('student_zip_code', with: '194-0021')
        select('東京都', from: 'student_prefecture_id')
        fill_in('student_city', with: '町田市')
        fill_in('student_address1', with: '中町1-2-3')
        fill_in('student_phone', with: '042-1234-5678')
        select('学生', from: 'student_job')
        fill_in('student_company', with: 'なし')
        fill_in('student_phone_company', with: '042-1234-5678')
        click_button '金融機関・支店を選択'
        click_button 'みずほ銀行'
        fill_in('bank_branch', with: 'とうきょう')
        click_button '東京営業部支店'
        click_button '完了'
        choose('student_bank_account_type_0')
        fill_in('student_bank_account_number', with: '1234567')
        click_button '次へ'

        # STEP4 各種届出
        find('label[for=student_pep_country_agreement]').click
        choose('student_pep_country_0')
        find('label[for=student_pep_peps_agreement]').click
        choose('student_pep_peps_false')
        find('label[for=student_pep_fatca_agreement]').click
        choose('student_pep_fatca_false')
        click_button '次へ'

        # STEP5 本人確認書類
        attach_file('identification_driver_license1', Rails.root.join('spec', 'fixtures', 'images', 'driver_license_front.jpg'))
        attach_file('identification_driver_license2', Rails.root.join('spec', 'fixtures', 'images', 'driver_license_back.jpg'))
        click_button '次へ'

        # STEP6 入力内容の確認
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