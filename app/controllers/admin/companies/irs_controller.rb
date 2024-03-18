class Admin::Companies::IrsController < Admin::AdminController
  before_action :set_company

  def show
    @ir = Company::Ir.find(params[:id])
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end