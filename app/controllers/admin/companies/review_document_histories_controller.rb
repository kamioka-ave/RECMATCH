class Admin::Companies::ReviewDocumentHistoriesController < Admin::AdminController
  before_action :set_company

  def index
    @document_histories = Company::ReviewDocumentHistory.where(company_id: @company.id)
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end