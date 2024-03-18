class Admin::Companies::IdentificationsController < Admin::AdminController
  before_action :set_company

  def approve
    @company.update!(
      is_identification_passed: true,
      identified_at: Time.now,
      identifier_id: current_admin.id
    )

    redirect_to admin_company_path(@company), notice: '本人確認OKにしました'
  end

  def reject
    @company.update!(
      is_identification_passed: false,
      identified_at: Time.now,
      identifier_id: current_admin.id
    )

    redirect_to admin_company_path(@company), notice: '本人確認NGにしました'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end