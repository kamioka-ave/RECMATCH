require 'rails_helper'

RSpec.describe Company::Ir, type: :model do
  describe '配信' do
    context '配信した場合' do
      include EmailSpec::Helpers
      include EmailSpec::Matchers

      before(:each) do
        FactoryBot.create(:admin)
        company_user = FactoryBot.create(:company_user)
        @company = company_user.company
        @project = FactoryBot.create(:project, company: @company)
        @product = FactoryBot.create(:product, project: @project)
        @student_user1 = FactoryBot.create(:student_user)
        @order1 = FactoryBot.create(
          :normal_order,
          user: @student_user1,
          product: @product,
          status: NormalOrder::S_COMPLETE,
          created_at: Time.zone.now - 1.day
        )
        @student_user2 = FactoryBot.create(:student_user)
        @order2 = FactoryBot.create(
          :normal_order,
          user: @student_user2,
          product: @product,
          status: NormalOrder::S_COMPLETE,
          created_at: Time.zone.now - 1.day
        )
        @ir = FactoryBot.create(
          :company_ir,
          company: @company,
          started_at: Time.zone.now + 1.minute,
          status: Company::Ir::S_WAITING
        )
        @ir.update_column(:started_at, Time.zone.now)
        @ir.notify!
      end

      it '学生にメールが配信されること' do
        expect(@ir.status).to eq Company::Ir::S_PUBLISHED
        expect(@ir.notified_at).not_to eq nil
        email = open_email(@student_user1.email)
        expect(email).to deliver_to(@student_user1.email)
        expect(email).to have_body_text(/IR情報を発信しました/)
        email = open_email(@student_user2.email)
        expect(email).to deliver_to(@student_user2.email)
        expect(email).to have_body_text(/IR情報を発信しました/)
      end
    end
  end
end
