# coding: utf-8
require 'rails_helper'

RSpec.describe 'Order', type: :model do
  describe '申込み、キャンセル待ち' do
    context 'プロジェクトが募集中の場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user = FactoryBot.create(:student_user)
      end

      it '正常に申込みできること' do
        normal_order = FactoryBot.build(:normal_order, user: @student_user, product: @product)
        normal_order.apply!
        email = open_email(@student_user.email)
        expect(email).to deliver_to(@student_user.email)
        expect(email).to have_body_text(/プロジェクトへのお申込みを受け付けました/)
      end

      it 'キャンセル待ちを申込みできないこと' do
        wait_order = WaitOrder.new(
          user_id: @student_user.id,
          product_id: @product.id
        )
        expect { wait_order.apply! }.to raise_error(WaitOrderExpiredError)
      end
    end

    context 'プロジェクトが上限応募額に達した場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        @company_user = FactoryBot.create(:company_user)
        @student_user1 = FactoryBot.create(:student_user, email: 'student1@example.com')
        @student_user2 = FactoryBot.create(:student_user, email: 'student2@example.com')
        @student_user3 = FactoryBot.create(:student_user, email: 'student3@example.com')
        @project = FactoryBot.create(:project, company: @company_user.company, solicit: 30_000, solicited: 0, solicit_limit: 50_000)
        @product1 = FactoryBot.create(:product, project: @project, price: 10_000)
        @product2 = FactoryBot.create(:product, project: @project, price: 20_000)
        @product3 = FactoryBot.create(:product, project: @project, price: 30_000)
        @order2 = FactoryBot.build(:normal_order, user: @student_user2, product: @product2)
        @order2.apply!
        @order3 = FactoryBot.build(:normal_order, user: @student_user3, product: @product3)
        @order3.apply!
      end

      it '申込みできないこと' do
        normal_order = FactoryBot.build(:normal_order, user: @student_user1, product: @product1)
        expect { normal_order.apply! }.to raise_error(ProjectReachedLimitError)
      end

      it '申込みできないこと（募集成立後）' do
        @project.succeed!
        normal_order = FactoryBot.build(:normal_order, user: @student_user1, product: @product1)
        expect { normal_order.apply! }.to raise_error(ProjectReachedLimitError)
      end

      it 'キャンセル待ちを申込みできること' do
        @project.succeed!

        wait_order = WaitOrder.new(
          user_id: @student_user1.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        wait_order.apply!

        email = open_email(@student_user1.email, with_subject: 'キャンセル待ちのお申込みを受け付けました')
        expect(email).to deliver_to(@student_user1.email)
        expect(email).to have_body_text(/キャンセル待ちのお申込みを受け付けました。/)
      end

      it 'キャンセル待ちをキャンセルできること' do
        @project.succeed!

        wait_order = WaitOrder.new(
          user_id: @student_user1.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        wait_order.apply!
        wait_order.cancel!
        expect(wait_order.status).to eq WaitOrder::S_CANCEL
        email = open_email(@student_user1.email, with_subject: 'キャンセル待ちのお申込みのキャンセルを受け付けました')
        expect(email).to deliver_to(@student_user1.email)
        expect(email).to have_body_text(/キャンセル待ちのお申込みのキャンセルを受け付けました。/)
      end

      it 'キャンセルが発生した場合、キャンセル待ちが申込まれること。' do
        @project.succeed!

        wait_order = WaitOrder.new(
          user_id: @student_user1.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        wait_order.apply!

        @order2.cancel!

        wait_order = wait_order.reload
        expect(wait_order.status).to eq WaitOrder::S_CONSUMED
        expect(wait_order.parent.status).to eq NormalOrder::S_NEW
      end

      it 'キャンセルが発生した場合、キャンセル待ちが受注される順番がキャンセル待ちの申込み順であること。' do
        @project.succeed!

        wait_order1 = WaitOrder.new(
          user_id: @student_user1.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        wait_order1.apply!

        wait_order2 = WaitOrder.new(
          user_id: @student_user2.id,
          product_id: @product1.id,
          contract_confirmed: true
        )
        wait_order2.apply!

        @order2.cancel!

        wait_order1 = wait_order1.reload
        wait_order2 = wait_order2.reload

        expect(wait_order1.status).to eq WaitOrder::S_CONSUMED
        expect(wait_order2.status).to eq WaitOrder::S_CONSUMED
        expect(wait_order1.parent.id < wait_order2.parent.id).to eq true
      end
    end
  end

  describe 'キャンセル' do
    context 'キャンセル期間内の場合' do
      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: company_user.company)
        product = FactoryBot.create(:product, project: @project)
        student_user = FactoryBot.create(:student_user)
        @normal_order = FactoryBot.build(:normal_order, user: student_user, product: product)
        @normal_order.apply!
      end

      it '正常にキャンセルできること' do
        r = @normal_order.cancel!
        @project.reload
        expect(@project.solicited).to eq 0
        expect(r).to eq true
      end
    end

    context 'キャンセル期間外の場合' do
      before(:each) do
        company_user = FactoryBot.create(:company_user)
        project = FactoryBot.create(:project, company: company_user.company)
        product = FactoryBot.create(:product, project: project)
        student_user = FactoryBot.create(:student_user)
        @normal_order = FactoryBot.build(:normal_order, user: student_user, product: product)
        @normal_order.apply!
        @normal_order.update!(
          created_at: @normal_order.created_at - 9.days
        )
      end

      it 'キャンセルできないこと' do
        expect { @normal_order.cancel! }.to raise_error(RuntimeError)
      end
    end
  end

  describe '失権' do
    context '全失権した場合' do
      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @loss_at = Time.now.in_time_zone('Asia/Tokyo')
        project = FactoryBot.create(:project, company: company_user.company, lost_at: @loss_at)
        product = FactoryBot.create(:product, project: project)
        student_user = FactoryBot.create(:student_user)
        @order = FactoryBot.create(
          :normal_order,
          user: student_user,
          product: product,
          execution_at: Date.today,
          status: NormalOrder::S_PAY_WAIT
        )
        @order.loss!(@loss_at)
      end

      it '失権状態であること' do
        expect(@order.canceled_at.to_s).to eq @loss_at.to_s
        expect(@order.status).to eq NormalOrder::S_LOST
        expect(@order.lost_orders.size).to eq 1

        lost_order = @order.lost_orders.first
        expect(lost_order.status).to eq LostOrder::S_ALL

        record = StudentTransactionRecord.find_by(order_id: @order.id)
        expect(record.transaction_at.to_s).to eq @loss_at.to_s
      end

      it '失権した学生にロックがかかっていること' do
        expect(@order.student.locked_at.present?).to be_truthy
      end
    end

    context '一部失権した場合' do
      before(:each) do
        company_user = FactoryBot.create(:company_user)
        @loss_at = Time.now.in_time_zone('Asia/Tokyo')
        project = FactoryBot.create(:project, company: company_user.company, lost_at: @loss_at)
        product1 = FactoryBot.create(:product, project: project, stocks: 1, price: 10_000)
        product2 = FactoryBot.create(:product, project: project, stocks: 2, price: 20_000)
        @student_user = FactoryBot.create(:student_user)
        @order = FactoryBot.create(
          :normal_order,
          user: @student_user,
          product: product2,
          execution_at: Date.today,
          status: NormalOrder::S_PAY_WAIT
        )
        @order.loss_and_payment!(@loss_at, product1.id, 1)
      end

      it '失権状態であること' do
        expect(@order.status).to eq NormalOrder::S_COMPLETE
        expect(@order.lost_orders.size).to eq 1

        lost_order = @order.lost_orders.first
        expect(lost_order.status).to eq LostOrder::S_PART

        record = StudentTransactionRecord.find_by(order_id: @order.id, transaction_type: StudentTransactionRecord::TR_INVESTOR_CANCEL)
        expect(record.transaction_at.to_s).to eq @loss_at.to_s
        expect(record.credit).to eq @order.lost_orders.reduce(0) { |sum, o| sum + o.price }

        report = OrderLostAndPaymentReport.find_by(order_id: @order.id)
        expect(report.user_id).to eq @student_user.id
      end

      it '失権した学生にロックがかかっていないこと' do
        expect(@order.student.locked_at.nil?).to be_truthy
      end
    end
  end
end
