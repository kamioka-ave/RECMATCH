class Mypage::Companies::DetailsController < Mypage::MypageController
  layout 'mypage_company'

  def show
    @company = current_user.company
  end

  def update
    @company = current_user.company
    @company.assign_attributes(company_params)

    if @company.save(context: :details)
      redirect_to mypage_company_path, notice: '詳細情報を更新しました'
    else
      render :show
    end
  end

private
  def company_params
    params.require(:company).permit(
      :user_id, :status, :this_year_employments, :last_year_employments, :business_summary, :business_philosophy, :hope,
      :business_shebang, :competitive_strength, :competitive_difference, :target, :ceo_hopes,
      company_capital_increases_attributes: [:id, :increased_on, :capital, :_destroy]
    )
  end
end