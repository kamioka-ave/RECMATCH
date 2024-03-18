require 'rails_helper'

RSpec.describe 'OrderInvoice', type: :model do
  describe '振込口座番号' do
    context '最後に振られた番号がないの場合' do
      it '2158000であること' do
        @invoice = OrderInvoice.new
        expect(@invoice.next_bank_account_number(nil)).to eq 2_158_000
      end
    end

    context '最後に振られた番号が2158000の場合' do
      it '2158001であること' do
        @invoice = OrderInvoice.new
        expect(@invoice.next_bank_account_number(2_158_000)).to eq 2_158_001
      end
    end

    context '最後に振られた番号が2158999の場合' do
      it '4700000であること' do
        @invoice = OrderInvoice.new
        expect(@invoice.next_bank_account_number(2_158_999)).to eq 4_700_000
      end
    end

    context '最後に振られた番号が4701999の場合' do
      it '2158000であること' do
        @invoice = OrderInvoice.new
        expect(@invoice.next_bank_account_number(4_701_999)).to eq 2_158_000
      end
    end
  end
end
