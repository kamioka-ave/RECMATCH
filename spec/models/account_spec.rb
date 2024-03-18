require 'rails_helper'

RSpec.describe 'Account', type: :model do
  describe '学生の振込' do
    context '残高がマイナス100000円で、100000円振り込んだ場合' do
      before(:each) do
        user = FactoryBot.create(:student_user)
        @account = user.account
        @account.update!(balance: -100_000)
        @record = StudentTransactionRecord.create!(
          user_id: user.id,
          transaction_type: StudentTransactionRecord::TR_PAYMENT,
          credit: 100_000
        )
      end

      it '残高が0であること' do
        @account = @account.reload
        expect(@record.balance).to eq 0
        expect(@account.balance).to eq 0
      end
    end
  end
end
