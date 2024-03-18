require 'rails_helper'

RSpec.describe 'StudentTransactionRecord', type: :model do
  describe '記録' do
    context '入金処理が前後した場合' do
      before(:all) do
        @user = FactoryBot.create(:student_user)
        @company_user = FactoryBot.create(:company_user)
        @project = FactoryBot.create(:project, company: @company_user.company, solicit: 30_000, solicited: 0, solicit_limit: 50_000)
        @product = FactoryBot.create(:product, project: @project, price: 10_000)
        @order = FactoryBot.build(:normal_order, user: @user, product: @product)

        @r1 = StudentTransactionRecord.create!(
          user_id: @user.id,
          student_id: @user.student.id,
          project_id: @project.id,
          company_id: @project.company_id,
          order_id: @order.id,
          transaction_type: StudentTransactionRecord::TR_EXECUTED,
          transaction_at: 5.hours.ago,
          depository: @product.price
        )

        @r2 = StudentTransactionRecord.create!(
          user_id: @user.id,
          student_id: @user.student.id,
          project_id: @project.id,
          company_id: @project.company_id,
          order_id: @order.id,
          transaction_type: StudentTransactionRecord::TR_EXECUTED,
          transaction_at: 3.hours.ago,
          depository: @product.price
        )

        @r3 = StudentTransactionRecord.create!(
          user_id: @user.id,
          student_id: @user.student.id,
          project_id: @project.id,
          company_id: @project.company_id,
          order_id: @order.id,
          transaction_type: StudentTransactionRecord::TR_PAYMENT,
          transaction_at: 4.hours.ago,
          credit: @product.price
        )

        @r4 = StudentTransactionRecord.create!(
          user_id: @user.id,
          student_id: @user.student.id,
          project_id: @project.id,
          company_id: @project.company_id,
          order_id: @order.id,
          transaction_type: StudentTransactionRecord::TR_PAYMENT,
          transaction_at: 2.hours.ago,
          credit: @product.price
        )
      end

      it '残高の整合性が取れていること' do
        expect(@r1.reload.balance).to eq -@product.price
        expect(@r2.reload.balance).to eq -@product.price
        expect(@r3.reload.balance).to eq 0
        expect(@r4.reload.balance).to eq 0
        expect(@user.account.reload.balance).to eq 0
      end
    end
  end
end
