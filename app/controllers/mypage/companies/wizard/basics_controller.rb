class Mypage::Companies::Wizard::BasicsController < Mypage::Companies::Wizard::BaseController
  def show
    @company = current_user.company.present? ? current_user.company : Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user_id = current_user.id
    @profile = current_user.profile

    if @company.save
      @profile.update!(name: @company.name, image: @company.image)
      #AdminMailer.company_registered(@company).deliver_later
      redirect_to mypage_company_wizard_confirm_path
    else
      @company.image.cache! if @company.image.present?
      render :show
    end
  end

  def update
    @company = current_user.company
    @profile = current_user.profile

    if @company.update(company_params)
      @profile.update!(name: @company.name, image: @company.image)
      redirect_to mypage_company_wizard_confirm_path
    else
      @company.image.cache! if @company.image.present?
      render :show
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :user_id, :name, :name_kana, :president_first_name, :president_first_name_kana, :president_last_name,
      :president_last_name_kana, :website, :image, :image_cache, :president_birth_on, :zip_code, :prefecture_id,
      :city, :address1, :address2, :phone, :birth_on, :employees, :capital, :sales_profit, :business_type_id
    )
  end
end