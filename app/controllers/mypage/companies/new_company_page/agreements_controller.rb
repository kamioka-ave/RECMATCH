class Mypage::Companies::NewCompanyPage::AgreementsController < Mypage::MypageController
  before_action :set_company

  def show; end

  def update
    @company.assign_attributes(company_params)
    @company.agree_with_pre_judge_at = Time.now

    if @company.valid?(:funding_agreement) && @company.save
      #AdminMailer.funding_submitted(@company).deliver_later
      redirect_to new_mypage_company_project_draft_path
    else
      render :show
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_params
    params.require(:company).permit(:user_id, :agree_with_clause, :agree_with_pre_judge)
  end
end