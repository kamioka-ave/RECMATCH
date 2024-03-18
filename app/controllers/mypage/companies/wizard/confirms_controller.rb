class Mypage::Companies::Wizard::ConfirmsController < Mypage::Companies::Wizard::BaseController
  def show
    @company = current_user.company
  end

  def update
    if current_user.confirmed_at.nil?
      return redirect_back(fallback_location: mypage_root_path)
    end

    @company = current_user.company
    @company.assign_attributes(company_params)
    @company.applied_at = Time.now

    if @company.save
      #AdminMailer.company_submitted(@company).deliver_later
      redirect_to mypage_company_wizard_complete_path
    else
      render :show
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :user_id, :status, :this_year_employments_reveal, :last_year_employments_reveal
    )
  end
end
