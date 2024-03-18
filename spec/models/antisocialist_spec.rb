require 'rails_helper'

RSpec.describe 'Antisocialist', type: :model do
  describe 'find_with_name' do
    before(:each) do
      @a1 = FactoryBot.create(
        :antisocialist,
        name: '友利　和雄',
        age: 51,
        created_at: '2011-08-30 09:00:00'
      )
      @a2 = FactoryBot.create(
        :antisocialist,
        name: '森川　弘明',
        age: 53,
        created_at: '2011-08-30 09:00:00'
      )
    end

    context 'リストにある場合' do
      before(:each) do
        date_format = '%Y%m%d'
        age = @a1.age + (Date.today.strftime(date_format).to_i - @a1.created_at.strftime(date_format).to_i) / 10_000
        @r = Antisocialist.find_with_name('友利', '和雄', age)
      end

      it '該当すること' do
        expect(@r).not_to eq nil
      end
    end

    context 'リストにない場合' do
      before(:each) do
        @r = Antisocialist.find_with_name('友利', '和雄', 20)
      end

      it '該当すること' do
        expect(@r).to eq nil
      end
    end
  end
end
