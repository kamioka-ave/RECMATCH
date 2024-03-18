class Mypage::Companies::Wizard::DetailsController < Mypage::Companies::Wizard::BaseController
  def show
    @company = current_user.company
  end

  def update
    @company = current_user.company
    @company.assign_attributes(company_params)

    if @company.valid?(:company_detail)
      @company.save
      redirect_to mypage_company_wizard_confirm_path
    else
      flash[:notice] = @company.errors.full_messages

      render :show
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :user_id, :status, :this_year_employments, :last_year_employments, :business_summary, :business_philosophy, :hope,
      :business_shebang, :competitive_strength, :competitive_difference, :target, :ceo_hopes
    )
  end
end