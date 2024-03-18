require 'rails_helper'

RSpec.describe JnbTransfer, type: :model do
  describe '和暦変換' do
    context '平成25年4月1日の場合' do
      time = JnbTransfer.time_from_wareki_string('250401213941')

      it '2013年4月1日となること' do
        expect(time.year).to eq 2013
        expect(time.month).to eq 4
        expect(time.day).to eq 1
      end
    end

    context '平成31年4月1日の場合' do
      time = JnbTransfer.time_from_wareki_string('310401213941')

      it '2019年4月1日となること' do
        expect(time.year).to eq 2019
        expect(time.month).to eq 4
        expect(time.day).to eq 1
      end
    end

    context 'XX1年5月1日の場合' do
      time = JnbTransfer.time_from_wareki_string('010501213941')

      it '2019年5月12日となること' do
        expect(time.year).to eq 2019
        expect(time.month).to eq 5
        expect(time.day).to eq 1
      end
    end
  end
end
