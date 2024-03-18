class Admin::CompaniesController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_company, only: [:show, :edit, :update, :activate]

  def index
    if current_admin.has_role?(:ir_checker)
      redirect_to access_denied_admin_pages_path
      return
    end

    @q = Company.includes(:project, :creator).order(updated_at: :desc).ransack(params[:q])
    @companies = @q.result.page(params[:page]).per(100)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧'
  end

  def show
    @company = Company.find(params[:id])
    @user = @company.user

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name
  end

  def new
    @user = User.new
    @user.build_company
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb '企業情報の編集'
  end

  def create
    @user = User.new(user_params)

    password = [*1..9, *'A'..'Z', *'a'..'z'].sample(8).join
    @user.password = password
    @user.password_confirmation = @user.password
    @user.build_profile
    @user.profile.name = '名無し'
    @user.build_account
    @user.skip_confirmation!
    @user.company.status = Company::S_APPLIED
    @user.company.creator_id = current_admin.id

    if @user.save
      redirect_to admin_companies_path, notice: '企業を登録しました'
    else
      @user.profile.image.cache! if @user.profile.image.present?
      @user.company.image.cache! if @user.company.image.present?
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to admin_company_path(@company), notice: '企業情報を更新しました'
    else
      @company.errors.add :base, :blank
      @company.image.cache! if @company.image.present?
      render :edit
    end
  end

  def toggle
    @company.toggle(params[:type])
    redirect_to admin_company_path(@company), notice: '企業を承認しました'
  end

  def activate
    if @company.user.confirmation_token.present? || @company.user.company_agreement.present?
      @company.update!(
        status: Company::S_ACTIVE,
        approver_id: current_admin.id,
        creator_id: nil
      )
      CompanyMailer.company_approved(@company).deliver_later
    else
      @company.update!(
        status: Company::S_TEMP_ACTIVE,
        approver_id: current_admin.id
      )
    end

    redirect_to admin_company_path(@company), notice: '企業を承認しました'
  end

  def complete_primary_sales_support
    @company.update_column(:primary_sales_support_completed, true)
  end

  def incomplete_primary_sales_support
    @company.update_column(:primary_sales_support_completed, false)
  end

  def complete_all_sales_support
    @company.update_column(:all_sales_support_completed, true)
  end

  def incomplete_all_sales_support
    @company.update_column(:all_sales_support_completed, false)
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_attributes
    [
      :user_id, :status, :name, :name_kana, :president_first_name, :president_first_name_kana, :president_last_name,:website,
      :president_last_name_kana, :president_birth_on, :zip_code, :prefecture_id, :city, :address1, :address2, :phone, :birth_on, :capital,
      :is_issuing, :is_restriction_of_transfer, :is_accounting, :is_audit, :has_board, :settlement_month, :settlement_day, :business_type_id,
      :board_members, :employees, :part_timers, :business_summary, :hope, :business_shebang, :issuable_stocks, :issued_stock,
      :competitive_strength, :competitive_difference, :how_to_exit, :how_to_exit_others, :target, :ceo_hopes,
      :capital_ties, :capital_ties_note, :image, :image_cache,
      :name_reveal, :president_name_reveal, :business_summary_reveal, :hope_reveal, :business_shebang_reveal, :competitive_strength_reveal,
      :ceo_hopes_reveal, :image_reveal, company_capital_increases_attributes: [:id, :increased_on, :capital, :_destroy],
      stock_histories_attributes: [:id, :price, :date, :partition_number]
    ]
  end

  def company_params
    params.require(:company).permit(company_attributes)
  end

  def user_params
    params.require(:user).permit(
      :email, :role_ids,
      profile_attributes: [
        :name, :image, :image_cache
      ],
      company_attributes: company_attributes
    )
  end
end
