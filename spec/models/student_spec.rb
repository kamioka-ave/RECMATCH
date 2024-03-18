# coding: utf-8
require 'rails_helper'

RSpec.describe 'Student', type: :model do
  before(:all) { @user = create :student_user }

  subject { @user.student }

  describe '更新処理' do
    context '名前に空白を含む場合' do
      before do
        @user.student.last_name = "  Foo  　 \n \t 　"
        @user.student.first_name = "    　Bar \n \t 　"
        #更新処理を書きたい @user.update
      end
      it '空白文字が削除されること' do
        pending 'このテストをかくにんしたい'
        expect(@user.student.full_name).to eq "FooBar"
      end
    end
  end

  describe '投資したプロジェクト' do
    context '投資した場合' do
      before(:each) do
        company_user = create(:company_user)
        project = create(:project, company: company_user.company, name: 'プロジェクト1')
        product = create(:product, project: project)
        @student_user = create(:student_user)
        order = build(:normal_order, user: @student_user, product: product)
        order.apply!
      end

      it '正常に取得できること' do
        expect(@student_user.student.invested_projects.include?('プロジェクト1')).to eq true
      end
    end

    context 'キャンセルした場合' do
      before(:each) do
        company_user = create(:company_user)
        project = create(:project, company: company_user.company, name: 'プロジェクト1')
        product = create(:product, project: project)
        @student_user = create(:student_user)
        order = build(:normal_order, user: @student_user, product: product)
        order.apply!
        order.cancel!
      end

      it '取得できないこと' do
        expect(@student_user.student.invested_projects.include?('プロジェクト1')).to eq false
      end
    end
  end

  describe '#profit_rate' do
    let(:student_user) { FactoryBot.create(:student_user) }
    subject { student_user.student.profit_rate }

    context "student hasn't invested" do
      it { is_expected.to eq 0 }
    end

    context 'student has invested' do
      def mock_getters(total_investment_price: nil, total_assets: nil)
        allow(student_user.student).to receive(:total_investment_price).and_return(total_investment_price)
        allow(student_user.student).to receive(:total_assets).and_return(total_assets)
      end

      it 'calculate the right percent when total assets == 0' do
        mock_getters(total_investment_price: 10_000, total_assets: 0)
        expect(subject).to eq(-100)
      end

      it 'calculate the right percent when total assets < total investment' do
        mock_getters(total_investment_price: 2343, total_assets: 1231)
        expect(subject).to eq(-47)
      end

      it 'calculate the right percent when total assets > total investment' do
        mock_getters(total_investment_price: 1231, total_assets: 2343)
        expect(subject).to eq 90
      end
    end
  end

  describe '#stock_per_complete_order' do
    let(:method) { subject.stock_per_complete_order }

    context 'Student has not invested in any project' do
      it 'cannot obtains any complete order' do
        expect(method).to be_empty
      end
    end

    context 'Invesor has already invested but did not complete any orders yet' do
      before do
        create :normal_order, status: Order::S_NEW, user: @user, student: subject
        create :cancel_order, status: Order::S_ABORTED, user: @user, student: subject
      end

      it 'cannot obtains any complete order' do
        expect(method).to be_empty
      end
    end

    context 'Invesor has already invested and complete 1 order without any loss' do
      let!(:normal_order) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }

      it 'has a complete order and possess stock amount same as that order amount' do
        expect(method.first.stock).to eq normal_order.amount
        expect(method.first.order_price).to eq normal_order.price
      end
    end

    context 'Invesor has already invest and complete 1 order that lose 2 parts' do
      let(:normal_order) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let!(:lost_orders) { create_list :lost_order, 2, status: LostOrder::S_PART, parent: normal_order, user: @user, student: subject }

      it 'should possess a complete order and right amount' do
        expect(method.first.stock).to eq normal_order.amount - lost_orders.reduce(0) { |s, o| s + o.amount }
        expect(method.first.order_price).to eq normal_order.price - lost_orders.reduce(0) { |s, o| s + o.price }
      end
    end

    context 'Invesor has already invest and complete 1 order but lose everything' do
      let(:normal_order) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let!(:lost_order) { create :lost_order, status: LostOrder::S_ALL, parent: normal_order, user: @user, student: subject }

      it 'should possess a complete order' do
        expect(method).to be_empty
      end
    end
  end

  describe '#total_assets' do
    let(:method) { subject.total_assets }

    context 'Student has not invested yet' do
      it 'should have zero assets' do
        expect(method).to eq 0
      end
    end

    context 'Student has invested in 2 companies' do
      let!(:order_on_company_a) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject } 
      let!(:order_on_company_b) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject } 
      let(:a_stock_history) { create :stock_history, company: order_on_company_a.company }
      let(:b_stock_history) { create :stock_history, company: order_on_company_b.company }

      context 'and both have no stock history' do
        it 'should have original assets without any change' do
          expect(method).to eq order_on_company_a.price + order_on_company_b.price
        end

        context 'but student has lost a part order on a company' do
          let!(:lost_order_on_company_a) do
            create :lost_order, parent: order_on_company_a, status: LostOrder::S_PART, user: @user, student: subject,
              project: order_on_company_a.project
          end

          it 'should have original assets subtracting the loss' do
            expect(method).to eq order_on_company_a.price + order_on_company_b.price - lost_order_on_company_a.price
          end
        end
      end

      context 'one has stock history while another one has not' do
        it 'should have a assets which is combination of above companies' do
          assets_on_a = order_on_company_a.amount * a_stock_history.real_price
          expect(method).to eq assets_on_a + order_on_company_b.price
        end
      end

      context 'and both have stock history' do
        it 'should have evaluated assets which is calculated precisely' do
          assets_on_a = order_on_company_a.amount * a_stock_history.real_price
          assets_on_b = order_on_company_b.amount * b_stock_history.real_price
          expect(method).to eq assets_on_a + assets_on_b
        end
      end
    end
  end

  describe '#assets_per_category' do
    let(:method) { subject.assets_per_category }

    context 'Student has invested in 2 categories of a company' do
      let(:order_on_category_a) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let(:order_on_category_b) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let!(:category_a) { create :category, projects: [order_on_category_a.project] }
      let!(:category_b) { create :category, projects: [order_on_category_b.project] }

      it 'should calculate right assets on each categories' do
        expect(method.first['assets']).to eq order_on_category_a.price
        expect(method.second['assets']).to eq order_on_category_b.price
      end
    end

    context 'Student has invested in 1 categories of 2 companies' do
      let(:order_on_company_a) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let(:order_on_company_b) { create :normal_order, status: Order::S_COMPLETE, user: @user, student: subject }
      let!(:category) { create :category, projects: [order_on_company_a.project, order_on_company_b.project] }

      it 'should have assets is sum of orders on 2 those companies' do
        expect(method.sum { |s| s['assets'] }).to eq order_on_company_a.price + order_on_company_b.price
      end
    end
  end
end
