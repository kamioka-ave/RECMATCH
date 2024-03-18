class Mypage::Companies::Wizard::AgreementsController < Mypage::Companies::Wizard::BaseController
  def show
    @agreement = current_user.company_agreement.present? ? current_user.company_agreement : CompanyAgreement.new

    # if Rails.env.development?
    #   @agreement.pdf1 = true
    #   @agreement.pdf2 = true
    #   @agreement.pdf3 = true
    # end
  end

  def create
    @agreement = CompanyAgreement.new(company_agreement_params)
    @agreement.user_id = current_user.id

    if @agreement.save
      redirect_to mypage_company_wizard_basic_path
    else
      render :show
    end
  end

  def update
    @agreement = current_user.company_agreement

    if @agreement.update(company_agreement_params)
      redirect_to mypage_company_wizard_basic_path
    else
      render :show
    end
  end

  private

  def company_agreement_params
    params.require(:company_agreement).permit(:user_id, :pdf1, :pdf2, :pdf3, :pdf4, :agreement)
  end
end