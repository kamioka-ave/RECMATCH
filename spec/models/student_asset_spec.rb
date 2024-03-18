require 'rails_helper'

RSpec.describe StudentAsset do
  describe '#to_json' do
    context 'Given student has not invested yet' do
      subject { StudentAsset.new [], [], [] }

      it 'have no timeline data and zero assets' do
        expect(subject.to_json).to eq []
      end
    end

    context 'Given student has invested in 3 company for a while' do
      let(:test_case) do
        [
          { company: 1, amount: 100, order_price: 1500 },
          { company: 1, stock_price: 1000 },
          { company: 1, amount: 124, order_price: 3500 },
          { company: 2, amount: 300, order_price: 3000 },
          { company: 1, stock_price: 5000 },
          { company: 2, amount: 400, order_price: 4000 },
          { company: 2, amount: 500, order_price: 5000 },
          { company: 2, stock_price: 20_000 },
          { company: 1, amount: 215, order_price: 3151 },
          { company: 3, amount: 99, order_price: 99_999 }
        ]
      end
      let(:test_result) do
        [
          1500,
          1000 * 100,
          1000 * 124,
          1000 * 124 + 3000,
          5000 * 124 + 3000,
          5000 * 124 + 4000,
          5000 * 124 + 5000,
          5000 * 124 + 500 * 20_000,
          5000 * 215 + 500 * 20_000,
          5000 * 215 + 500 * 20_000 + 99_999
        ]
      end

      subject do
        StudentAsset.new(*test_case.each_with_index.each_with_object([[], [], Set.new]) do |(elm, i), acc|
          if elm.key? :amount
            acc[1] << double(date: i, company_id: elm[:company], accumulation: elm.slice(:amount, :order_price))
          elsif elm.key? :stock_price
            acc[0] << double(date: i, company_id: elm[:company], real_price: elm[:stock_price])
          end
          acc[2] << elm[:company]
        end.tap { |params| params[2] = params[2].to_a })
      end

      (0...10).each do |time|
        context "at event no ##{time}" do
          it 'should calculate right assets' do
            expect(subject.to_json[time][:value]).to eq test_result[time]
          end
        end
      end
    end
  end
end
