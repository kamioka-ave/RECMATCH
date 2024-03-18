class Mypage::Companies::Eventorder::AgreementsController < Mypage::MypageController
  before_action :set_company

  def show; end

  def update
    @existagreeement = EventAgreement.find_by(company_id: @company.id)

    if @existagreeement.nil?
      @agreement = EventAgreement.new(agreement_params)
      @agreement.company_id = @company.id

      if @agreement.save
        redirect_to new_mypage_company_event_draft_path
      else
        render :show
      end

    else
      redirect_to new_mypage_company_event_draft_path
    end

  end

  private

  def set_company
    @company = current_user.company
  end

  def agreement_params
    params.require(:event_agreement).permit(:agree_with_clause, :agree_with_pre_judge)
  end
end