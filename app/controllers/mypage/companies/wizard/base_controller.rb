class Mypage::Companies::Wizard::BaseController < Mypage::MypageController
  before_action :check_company_status

  private

  def check_company_status
    if current_user.company.present? && [Company::S_ACTIVE, Company::S_REJECTED, Company::S_TEMP_ACTIVE].include?(current_user.company.status)
      redirect_to mypage_root_path
    end
  end
end