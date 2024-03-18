class Admin::Companies::AntisocialsController < Admin::AdminController
  before_action :set_company

  def approve
    @company.update!(
      is_antisocial_check_passed: true,
      antisocial_checked_at: Time.now,
      antisocial_checker_id: current_admin.id
    )
    redirect_to admin_company_path(@company), notice: '反社チェックOKにしました'
  end

  def reject
    @company.update!(
      is_antisocial_check_passed: false,
      antisocial_checked_at: Time.now,
      antisocial_checker_id: current_admin.id,
      status: Company::S_REJECTED
    )
    redirect_to admin_company_path(@company), notice: '反社チェックNGにしました'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end