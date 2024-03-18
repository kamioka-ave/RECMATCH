class Admin::Projects::CompanyTransactionRecordsController < Admin::AdminController
  before_action :set_project

  def new
    @record = CompanyTransactionRecord.new
  end

  def create
    @record = CompanyTransactionRecord.new(company_transaction_record_params)
    @record.user_id = @project.company.user_id
    @record.company_id = @project.company_id
    @record.project_id = @project.id

    if @record.save
      render :create
    else
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def company_transaction_record_params
    params.require(:company_transaction_record).permit(
      :transaction_type, :transaction_at, :depository, :credit
    )
  end
end