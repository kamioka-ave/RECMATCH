class Admin::Companies::RejectReasonsController < Admin::AdminController
  before_action :set_company

  def update
    @company.assign_attributes(company_params)

    if !@company.valid?(:reject) || !@company.save
      render :show
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def company_params
    params.require(:company).permit(:status, :reject_reason)
  end
end