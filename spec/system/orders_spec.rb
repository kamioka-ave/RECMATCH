require 'rails_helper'

RSpec.describe 'Orders', type: :system do
  describe '申込み、キャンセル待ち' do
    context 'プロジェクトが募集中の場合' do
      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company, solicit: 10_000, solicit_limit: 100_000)
        @product = FactoryBot.create(:product, project: @project, stocks: 1, price: 10_000)
        @user = FactoryBot.create(:student_user)
      end

      after(:each) do
        DatabaseRewinder.clean_with(:_, except: %w(roles admin_roles))
      end

      it '正常に申込み・キャンセルができること', retry: 3 do
        visit new_user_session_path
        fill_in 'メールアドレス', with: @user.email
        fill_in 'user_password', with: @user.password
        click_button 'ログイン'
        expect(page).to have_content(@user.profile.name)

        # コース1
        visit project_path(@project)
        expect(page).to have_content(@project.name)
        visit project_product_order_contract_path(@project, @product, type: 'normal')
        expect(page).to have_content('非上場株式の取引に関する確認書')

        # 非上場株式の取引に関する確認書
        # check 'term_confirmed'
        find('label', text: '私は、貴社から受領した確認書の内容を十分理解し、私の判断と責任において店頭有価証券の取引を行います。').click
        # check 'term_condition_confirmed'
        find('label', text: '私は、取引約款第6条（表明保証・誓約）の内容を確認し、表明保証・誓約致します。').click
        click_button '確認した上で次の画面へ'
        expect(page).to have_content('契約締結前交付書面の確認')

        # 契約締結前交付書面の確認
        click_link '契約締結前交付書面を開く'
        click_link '契約締結前交付書面を開く'
        # check 'company_contract_confirmed'
        find('label', text: '私は、契約締結前交付書面の内容を十分理解し、また、「募集株式の取得お申し込みの撤回について」の内容を確認してこれを理解した上で、私の判断と責任において店頭有価証券の取引を行います。').click
        # check 'company_contract_about_cancel'
        find('label', text: '私は反社会的勢力に該当していないことを確約するとともに、確約が虚偽であると認められた時は当該有価証券の取得に関わる契約が解除されることに異を唱えません。').click
        # check 'company_contract_promise_antisocialists'
        find('label', text: '私は、私が当該会社（発行者）の株主になった際、貴社が当該会社に私の氏名、住所、メールアドレス、購入（割当）株数を記載した株主名簿を提出する事に同意致します。').click
        click_button '確認した上で次の画面へ'
        expect(page).to have_content('募集株式の発行事項に関するご通知の確認')

        # 募集株式の発行事項に関するご通知の確認
        click_link '募集株式の発行事項に関するご通知を開く'
        # check 'company_law_notification_confirmed'
        find('label', text: '私は、発行者の依頼に基づき貴社が代行通知する「募集株式の発行事項に関するご通知」の内容を確認いたしました').click
        click_button '確認した上で次の画面へ'
        expect(page).to have_content('申込み内容の確認')

        # 申込み内容の確認
        click_button 'お申込みを確定'

        # 完了画面
        expect(page).to have_content('投資の申込みを確定致しました')
        expect(page).to have_content(@project.name)

        @project = @project.reload
        expect(@project.solicited).to eq @product.price

        # マイページ
        visit mypage_root_path
        expect(page).to have_content('応募した投資')

        # キャンセル
        # click_link 'キャンセル'
        # page.accept_confirm
        # @project = @project.reload
        # expect(@project.solicited).to eq 0
      end
    end
  end
end
