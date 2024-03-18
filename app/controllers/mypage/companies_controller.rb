class Mypage::CompaniesController < Mypage::MypageController
  before_action :set_company, only: [:edit, :update]
  layout 'mypage_company'

  def edit; end

  def update
    if company_params.has_key?(:image)
      @company.update!(image_draft: company_params[:image])
    end

    @company.attributes = company_params

    if @company.draft_update
      #AdminMailer.company_draft_submitted(@company).deliver_later
      redirect_to mypage_company_path, notice: '会社情報の更新依頼を行いました'
    else
      @company.image.cache! unless @company.image.blank?
      render :edit
    end
  end

  private

  def set_company
    @company = current_user.company
  end

  def company_params
    params.require(:company).permit(
      :user_id, :name, :name_kana, :president_first_name, :president_first_name_kana, :president_last_name,
      :president_last_name_kana, :president_birth_on, :zip_code, :prefecture_id, :city, :address1, :address2, :phone, :is_issuing, :is_accounting, :is_audit, :has_board,
      :market_cap, :issued_stock, :stage, :capital, :is_restriction_of_transfer, :birth_on, :accounting_started_on, :settlement_month, :settlement_day, :website, :image, :image_cache
    )
  end
end