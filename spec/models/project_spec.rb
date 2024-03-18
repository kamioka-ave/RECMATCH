require 'rails_helper'

RSpec.describe 'Project', type: :model do
  describe '募集成立判定' do
    context '目標応募額200万、上限応募額300万の場合' do
      before(:each) do
        @project = FactoryBot.create(
          :project,
          solicit: 2_000_000,
          solicit_limit: 3_000_000,
          finish_at: Time.now
        )
        FactoryBot.create(:product, project: @project)
      end

      it '申込み200万の場合に募集成立となること' do
        @project.solicited = 2_000_000
        expect(@project.succeeded?).to eq true
      end

      it '申込み250万の場合に募集成立となること' do
        @project.solicited = 2_500_000
        expect(@project.succeeded?).to eq true
      end

      it '申込み180万の場合に募集不成立となること' do
        @project.solicited = 1_800_000
        expect(@project.succeeded?).to eq false
      end

      it '締切日が過ぎてない場合は募集不成立となること' do
        @project.solicited = 2_000_000
        @project.finish_at = 1.days.since
        expect(@project.succeeded?).to eq false
      end
    end
  end

  describe '約定日とか' do
    context '募集成立日が2016/10/21(金)の場合' do
      before(:each) do
        @project = FactoryBot.build(
          :project,
          succeeded_at: DateTime.new(2016, 10, 21)
        )
      end

      it '約定日は2016/10/29(土)であること' do
        execution_at = @project.calc_execution_at
        expect(execution_at.year).to eq 2016
        expect(execution_at.month).to eq 10
        expect(execution_at.day).to eq 29
      end

      it '最終支払日は2016/11/2(水)であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        expect(payment_at.year).to eq 2016
        expect(payment_at.month).to eq 11
        expect(payment_at.day).to eq 2
      end

      it '失権日時は2016/11/12 23:59:00であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        lost_at = @project.calc_lost_at(payment_at)
        expect(lost_at.year).to eq 2016
        expect(lost_at.month).to eq 11
        expect(lost_at.day).to eq 12
        expect(lost_at.hour).to eq 23
        expect(lost_at.min).to eq 59
        expect(lost_at.sec).to eq 0
      end

      it '受渡日は2016/11/4(金)であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        deliv_at = @project.calc_deliv_at(payment_at)
        expect(deliv_at.year).to eq 2016
        expect(deliv_at.month).to eq 11
        expect(deliv_at.day).to eq 4
      end
    end

    context '上限に達して2016/10/21(金)に募集が成立した場合' do
      before(:each) do
        @project = FactoryBot.build(
          :project,
          finish_at: DateTime.new(2016, 10, 23),
          succeeded_at: DateTime.new(2016, 10, 21),
          is_succeeded_with_limit: true
        )
      end

      it '約定日は2016/10/30(日)であること' do
        execution_at = @project.calc_execution_at
        expect(execution_at.year).to eq 2016
        expect(execution_at.month).to eq 10
        expect(execution_at.day).to eq 30
        expect(execution_at.hour).to eq 0
        expect(execution_at.min).to eq 0
        expect(execution_at.sec).to eq 0
      end

      it '支払開始日は2016/10/31(月)であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        expect(payment_at.year).to eq 2016
        expect(payment_at.month).to eq 11
        expect(payment_at.day).to eq 2
      end

      it '最終支払日は2016/11/2(水)であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        expect(payment_at.year).to eq 2016
        expect(payment_at.month).to eq 11
        expect(payment_at.day).to eq 2
      end

      it '失権日時は2016/11/12 23:59:00であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        lost_at = @project.calc_lost_at(payment_at)
        expect(lost_at.year).to eq 2016
        expect(lost_at.month).to eq 11
        expect(lost_at.day).to eq 12
        expect(lost_at.hour).to eq 23
        expect(lost_at.min).to eq 59
        expect(lost_at.sec).to eq 0
      end

      it '受渡日は2016/11/4(金)であること' do
        execution_at = @project.calc_execution_at
        payment_at = @project.calc_payment_at(execution_at)
        deliv_at = @project.calc_deliv_at(payment_at)
        expect(deliv_at.year).to eq 2016
        expect(deliv_at.month).to eq 11
        expect(deliv_at.day).to eq 4
      end
    end

    context '約定日が2017/12/28(木)の場合（年末年始、祝日を挟む場合）' do
      before(:each) do
        @project = FactoryBot.build(
          :project,
          execution_at: DateTime.new(2017, 12, 28)
        )
      end

      it '最終支払日は2018/1/9(火)であること' do
        payment_at = @project.calc_payment_at(@project.execution_at)
        expect(payment_at.year).to eq 2018
        expect(payment_at.month).to eq 1
        expect(payment_at.day).to eq 9
      end
    end

    context '約定日が2018/3/15(木)の場合（支払い期間に祝日を挟む場合）' do
      before(:each) do
        @project = FactoryBot.build(
          :project,
          execution_at: DateTime.new(2018, 3, 15)
        )
      end

      it '支払開始日は2018/3/19(月)であること' do
        payment_start_on = @project.calc_payment_start_on(@project.execution_at)
        expect(payment_start_on.year).to eq 2018
        expect(payment_start_on.month).to eq 3
        expect(payment_start_on.day).to eq 19
      end

      it '最終支払日は2018/3/22(木)であること' do
        payment_at = @project.calc_payment_at(@project.execution_at)
        expect(payment_at.year).to eq 2018
        expect(payment_at.month).to eq 3
        expect(payment_at.day).to eq 22
      end
    end
  end

  describe '募集成立時の処理' do
    context '募集が成立した場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user = FactoryBot.create(:student_user)
        @project = FactoryBot.create(:project, company: company_user.company, solicit: 10_000, solicited: 0, solicit_limit: 20_000)
        @product = FactoryBot.create(:product, project: @project, price: 10_000)
        @order = FactoryBot.build(:normal_order, user: @student_user, product: @product)
        @order.apply!
        @project.update!(finish_at: Time.now)
        ProjectFinishJob.perform_now(@project.id)
        @project.reload
      end

      it '状態が募集成立になること' do
        expect(@project.status).to eq Project::S_SUCCEEDED
        expect(@project.is_succeeded_with_limit).to eq false
        expect(@project.succeeded_price).to eq 10_000
      end

      it '募集成立のメールが学生に送信されること' do
        email = open_email(@student_user.email, with_subject: 'お申込みのプロジェクトの募集期間が終了しました')
        expect(email).to deliver_to(@student_user.email)
        expect(email).to have_body_text(/今日より9日目が到来した時点で目標募集額を下回ることがなければ、当該プロジェクトが成立いたします/)
      end
    end

    context '申込みが募集上限に達した場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user = FactoryBot.create(:student_user)
        @project = FactoryBot.create(:project, company: company_user.company, solicit: 10_000, solicited: 10_000, solicit_limit: 20_000)
        @product = FactoryBot.create(:product, project: @project, price: 10_000)
        @order = FactoryBot.build(:normal_order, user: @student_user, product: @product)
        @order.apply!
        @project.reload
      end

      it '状態が募集成立になること' do
        expect(@project.status).to eq Project::S_SUCCEEDED
        expect(@project.is_succeeded_with_limit).to eq true
        expect(@project.succeeded_price).to eq 20_000
      end

      it '募集成立のメールが学生に送信されること' do
        email = open_email(@student_user.email, with_subject: 'お申込みのプロジェクトの募集期間が終了しました')
        expect(email).to deliver_to(@student_user.email)
        expect(email).to have_body_text(/これから24時間（募集最終日の場合はその日が終了する迄）に限りキャンセル待ちのお申込みをお受けいたします/)
      end
    end
  end

  describe '募集不成立時の処理' do
    context '申込期間終了時に募集が不成立の場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user = FactoryBot.create(:student_user)
        @project = FactoryBot.create(:project, company: company_user.company, solicit: 200_000, solicited: 0, solicit_limit: 300_000)
        @product = FactoryBot.create(:product, project: @project, price: 100_000)
        @order = FactoryBot.build(:normal_order, user: @student_user, product: @product)
        @order.apply!
        @project.update!(finish_at: Time.now)
        ProjectFinishJob.perform_now(@project.id)
        @project.reload
      end

      it '状態が募集不成立になること' do
        expect(@project.status).to eq Project::S_FAILED
        expect(@project.failed_at).not_to eq nil
      end

      it '募集不成立のメールが学生に送信されること' do
        email = open_email(@student_user.email, with_subject: 'お申込みのプロジェクトが不成立となりました')
        expect(email).to deliver_to(@student_user.email)
        expect(email).to have_body_text(/募集期間終了時に応募額が目標募集額に到達しなかったため、/)
      end

      it '申込みがキャンセルになっていること' do
        expect(@order.reload.status).to eq NormalOrder::S_CANCEL
      end
    end

    context '申込期間終了後キャンセル発生により募集が不成立の場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @student_user2 = FactoryBot.create(:student_user, email: 'student2@example.com')
        @project = FactoryBot.create(:project, company: company_user.company, solicit: 100_000, solicited: 0, solicit_limit: 200_000)
        @product = FactoryBot.create(:product, project: @project, price: 50_000)
        @order1 = FactoryBot.build(:normal_order, user: @student_user1, product: @product)
        @order1.apply!
        @order2 = FactoryBot.build(:normal_order, user: @student_user2, product: @product)
        @order2.apply!
        @project.update!(finish_at: Time.now)
        ProjectFinishJob.perform_now(@project.id)
        @order1.cancel!
        @project.reload
      end

      it '状態が募集不成立になること' do
        expect(@project.status).to eq Project::S_FAILED
        expect(@project.failed_at).not_to eq nil
      end

      it '募集不成立のメールが学生に送信されること' do
        email = open_email(@student_user2.email, with_subject: 'お申込みのプロジェクトが不成立となりました')
        expect(email).to deliver_to(@student_user2.email)
        expect(email).to have_body_text(/その後のキャンセル等で目標募集額を下回ってしまったため、/)
      end

      it '申込みがキャンセルになっていること' do
        expect(@order2.reload.status).to eq NormalOrder::S_CANCEL
      end
    end
  end

  describe '約定時の処理' do
    it '正常' do
      company_user = FactoryBot.create(:company_user)
      company = FactoryBot.create(:company, user: company_user)
      project = FactoryBot.create(:project, company: company, solicited: 1000, stock_price: 100)
      project.succeed!
      project.execute!
      expect(project.status).to eq Project::S_EXECUTED
      expect(project.execution_price).to eq 1000
    end
  end

  describe '申込み' do
    context '同時に複数の申込みがあった場合' do
      before(:each) do
        @company_user = FactoryBot.create(:company_user)
        @student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @student_user2 = FactoryBot.create(:student_user, email: 'student2@example.com')
        @student_user3 = FactoryBot.create(:student_user, email: 'student3@example.com')
        @student_user4 = FactoryBot.create(:student_user, email: 'student4@example.com')
        @student_user5 = FactoryBot.create(:student_user, email: 'student5@example.com')
        @student_user6 = FactoryBot.create(:student_user, email: 'student6@example.com')
        @project = FactoryBot.create(:project, company: @company_user.company, solicit: 10_000, solicited: 0, solicit_limit: 20_000)
        @product = FactoryBot.create(:product, project: @project, price: 10_000)
      end

      it '上限を超えて申込みできないこと' do
        threads = []
        errors = []

        Student.all.each do |i|
          order = NormalOrder.new(
            user_id: i.user_id,
            product_id: @product.id,
            contract_confirmed: true
          )
          threads << Thread.new do
            ActiveRecord::Base.connection_pool.with_connection do
              begin
                order.apply!
              rescue => e
                errors.push(e)
              end
            end
          end
        end

        threads.each(&:join)

        @project.reload
        expect(@project.solicited).to eq @project.solicit_limit
        expect(errors.size).to eq 4
      end
    end

    context '同時に複数の申込みとキャンセルがあった場合' do
      before(:each) do
        @company_user = FactoryBot.create(:company_user)
        @student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @student_user2 = FactoryBot.create(:student_user, email: 'student2@example.com')
        @student_user3 = FactoryBot.create(:student_user, email: 'student3@example.com')
        @student_user4 = FactoryBot.create(:student_user, email: 'student4@example.com')
        @student_user5 = FactoryBot.create(:student_user, email: 'student5@example.com')
        @student_user6 = FactoryBot.create(:student_user, email: 'student6@example.com')
        @project = FactoryBot.create(:project, company: @company_user.company, solicit: 10_000, solicited: 0, solicit_limit: 70_000)
        @product = FactoryBot.create(:product, project: @project, price: 10_000)
      end

      it '集まっている金額が正常なこと' do
        threads = []

        Student.all.each do |i|
          order = NormalOrder.new(
            user_id: i.user_id,
            product_id: @product.id,
            contract_confirmed: true
          )
          threads << Thread.new do
            ActiveRecord::Base.connection_pool.with_connection do
              order.apply!
              order.cancel!
            end
          end
        end

        threads.each(&:join)

        @project.reload
        expect(@project.solicited).to eq 0
      end
    end
  end

  describe '申込み' do
    context '同時に複数の申込みがあった場合' do
      before(:each) do
        @company_user = FactoryBot.create(:company_user)
        @student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @student_user2 = FactoryBot.create(:student_user, email: 'student2@example.com')
        @student_user3 = FactoryBot.create(:student_user, email: 'student3@example.com')
        @student_user4 = FactoryBot.create(:student_user, email: 'student4@example.com')
        @student_user5 = FactoryBot.create(:student_user, email: 'student5@example.com')
        @student_user6 = FactoryBot.create(:student_user, email: 'student6@example.com')
        @student_user7 = FactoryBot.create(:student_user, email: 'student7@example.com')
        @student_user8 = FactoryBot.create(:student_user, email: 'student8@example.com')
        @student_user9 = FactoryBot.create(:student_user, email: 'student9@example.com')
        @student_user10 = FactoryBot.create(:student_user, email: 'student10@example.com')
        @student_user11 = FactoryBot.create(:student_user, email: 'student11@example.com')
        @student_user12 = FactoryBot.create(:student_user, email: 'student12@example.com')
        @project = FactoryBot.create(:project, company: @company_user.company, solicit: 30_000, solicited: 0, solicit_limit: 100_000)
        @product1 = FactoryBot.create(:product, project: @project, price: 10_000)
        @product2 = FactoryBot.create(:product, project: @project, price: 30_000)
        @product3 = FactoryBot.create(:product, project: @project, price: 50_000)

        @order1 = NormalOrder.new(
          user_id: @student_user1.id,
          product_id: @product3.id,
          contract_confirmed: true
        )
        @order1.apply!

        @order2 = NormalOrder.new(
          user_id: @student_user2.id,
          product_id: @product2.id,
          contract_confirmed: true
        )
        @order2.apply!

        @order3 = NormalOrder.new(
          user_id: @student_user1.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @order3.apply!

        @order4 = NormalOrder.new(
          user_id: @student_user2.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @order4.apply!

        @wait_order1 = WaitOrder.new(
          user_id: @student_user3.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @wait_order1.apply!

        @wait_order2 = WaitOrder.new(
          user_id: @student_user4.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @wait_order2.apply!

        @wait_order3 = WaitOrder.new(
          user_id: @student_user5.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @wait_order3.apply!

        @wait_order4 = WaitOrder.new(
          user_id: @student_user6.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        @wait_order4.apply!

        @wait_order5 = WaitOrder.new(
          user_id: @student_user7.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
      end

      it '上限を超えて申込みできないこと' do
        threads = []

        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            @wait_order5.apply!
          end
        end

        threads << Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            @order2.cancel!
          end
        end

        threads.each(&:join)

        @project.reload
        expect(@project.solicited).to eq @project.solicit_limit

        orders = Order.where(project_id: @project.id)
        expect(orders.size).to eq 13
      end
    end
  end
end
