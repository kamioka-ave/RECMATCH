class Mypage::Companies::AgreementsController < Mypage::MypageController
  def show
    @agreement = current_user.company_agreement.present? ? current_user.company_agreement : CompanyAgreement.new

    if Rails.env.development?
      @agreement.pdf1 = true
      @agreement.pdf2 = true
      @agreement.pdf3 = true
    end
  end

  def create
    @agreement = CompanyAgreement.new(company_agreement_params)
    @agreement.user_id = current_user.id

    ActiveRecord::Base.transaction do
      @agreement.save!
      current_user.company.update!(
        status: Company::S_ACTIVE,
        creator_id: nil
      )
    end
    redirect_to mypage_root_path
  rescue
    render :show
  end

  def update
    @agreement = current_user.company_agreement

    if @agreement.update(company_agreement_params) && current_user.company.update(status: Company::S_ACTIVE)
      redirect_to mypage_root_path
    else
      render :show
    end
  end

  private

  def company_agreement_params
    params.require(:company_agreement).permit(:user_id, :pdf1, :pdf2, :pdf3, :pdf4, :agreement, :terms10_agreed)
  end
end
