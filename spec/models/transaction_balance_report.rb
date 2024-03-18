require 'rails_helper'

RSpec.describe TransactionBalanceReport, type: :model do
  describe '残高報告書の交付' do
    let(:start_on) { 3.months.ago.to_date.in_time_zone('Asia/Tokyo') }
    let(:end_on) { Date.today.in_time_zone('Asia/Tokyo') }

    context '申込みが交付の前日に約定した場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, end_on.yesterday, start_on, end_on)
      end

      it '交付されること' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq true
      end
    end

    context '申込みが交付の3ヶ月前に約定した場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, 3.months.ago.beginning_of_day, start_on, end_on)
      end

      it '交付されること' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq true
      end
    end

    context '申込みが交付の3ヶ月前に受渡された場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, 3.months.ago.beginning_of_day - 4.days, start_on, end_on)
      end

      it '交付されること' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq true
      end
    end

    context '申込みが交付の3ヶ月前に約定した場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, Date.today, start_on, end_on)
      end

      it '交付されないこと' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq false
      end
    end

    context '申込みがない場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
      end

      it '交付されないこと' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq false
      end
    end

    context '12〜15ヶ月に申込みが受渡され、それ以降申込みがない場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, 15.months.ago.beginning_of_day, start_on, end_on)
      end

      it '交付されること' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq true
      end
    end

    context '15〜18ヶ月に申込みが受渡され、それ以降申込みがない場合' do
      before(:each) do
        @user = FactoryBot.create(:student_user)
        report_transaction_balance(@user, 18.months.ago.beginning_of_day, start_on, end_on)
      end

      it '交付されないこと' do
        expect(TransactionBalanceReport.exists?(user_id: @user.id)).to eq false
      end
    end
  end

  def report_transaction_balance(user, execution_at, start_on, end_on)
    company_user = FactoryBot.create(:company_user)
    project = FactoryBot.create(
      :project,
      company: company_user.company,
      solicit: 30_000,
      solicited: 0,
      solicit_limit: 50_000,
      execution_at: execution_at
    )
    payment_at = project.calc_payment_at(execution_at)
    deliv_at = project.calc_deliv_at(payment_at)
    product = FactoryBot.create(
      :product,
      project: project,
      price: 10_000
    )
    order = FactoryBot.create(
      :normal_order,
      user: user,
      product: product,
      execution_at: execution_at,
      deliv_at: deliv_at
    )
    StudentTransactionRecord.create!(
      user_id: user.id,
      student_id: user.student.id,
      project_id: project.id,
      company_id: project.company_id,
      order_id: order.id,
      transaction_type: StudentTransactionRecord::TR_EXECUTED,
      transaction_at: execution_at,
      depository: product.price
    )
    user.student.report_transaction_balance(start_on, end_on)
  end
end
