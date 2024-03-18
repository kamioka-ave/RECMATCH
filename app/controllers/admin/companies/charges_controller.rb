class Admin::Companies::ChargesController < Admin::AdminController
  before_action :set_company

  def new
    @admin_company = AdminCompany.new
  end

  def create
    @admin_company = AdminCompany.new(admin_company_params)

    unless @admin_company.save
      render :new
    end
  end

  def destroy
    @admin_company = AdminCompany.find(params[:id])
    @admin_company.destroy
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def admin_company_params
    params.require(:admin_company).permit(:admin_id, :company_id)
  end
end
