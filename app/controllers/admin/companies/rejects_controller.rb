class Admin::Companies::RejectsController < Admin::AdminController
  before_action :set_company

  def show
    @company.reject_mail = true
  end

  def update
    @company.assign_attributes(company_params)
    if @company.save(context: :reject)
      if @company.reject_mail
        CompanyMailer.company_rejected(@company).deliver_later
      end
    else
      render :show
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def company_params
    params.require(:company).permit(:status, :reject_reason, :reject_mail)
  end
end