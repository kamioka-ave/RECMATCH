class Admin::Companies::Irs::StudentsController < Admin::AdminController
  before_action :set_company, :set_ir

  def index
    unless current_admin.has_role?(:business_manager)
      return redirect_to(access_denied_admin_pages_path)
    end

    @q = Company::IrStudent.includes(:message, [student: :user])
           .where(company_ir_id: @ir)
           .ransack(params[:q])
    @ir_students = @q.result.page(params[:page]).per(100)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb "#{@ir.title}の配信先一覧"
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_ir
    @ir = Company::Ir.find(params[:ir_id])
  end
end