class Admin::Companies::StatusHistoriesController < Admin::AdminController
  before_action :set_company

  def index
    @status_histories = CompanyStatusHistory.where(company_id: @company.id)
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end