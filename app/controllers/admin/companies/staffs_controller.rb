class Admin::Companies::StaffsController < Admin::AdminController
  before_action :set_company
  before_action :set_breadcrumb, only: %i(index new create)
  before_action :set_staff, only: [:destroy, :restore]

  def index
    @companies = Company.chat_on.select(:id, :name).as_json(only: [:id, :name], without_avatar: true)
    @staffs = @company.staffs.includes(:user).page(params[:page])
  end

  def new
    @user = User.new.tap(&:build_staff)
  end

  def create
    @user = User.new(user_params).tap(&:build_profile).tap(&:build_account)
    @user.skip_confirmation!
    if @user.save
      #AdminMailer.staff_registered(@user, @company).deliver_now
      redirect_to admin_company_staffs_path(company_id: @company), notice: 'メール送信が完了しました'
    else
      render :new
    end
  end

  def destroy
    redirect_to admin_company_staffs_path(company_id: @company) if @staff.reject
  end

  def restore
    staff_user = @staff.user
    redirect_to admin_company_staffs_path(company_id: @company) if @staff.update(rejected_at: nil) &&
                                                                  staff_user.update(deleted_at: nil)
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_staff
    @staff = Staff.with_deleted.find(params[:id])
  end

  def set_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb '相談用アカウントの追加'
  end

  def user_params
    params.require(:user).permit(User::PERMITTED_PARAMS)
  end
end
