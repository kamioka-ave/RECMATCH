class Admin::AdminsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    @q = Admin.includes(:roles).ransack(params[:q])
    @admins = @q.result.page(params[:page]).per(30)
  end

  def edit; end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    @admin.build_students_display

    if @admin.save
      redirect_to admin_admins_path, notice: '管理者を追加しました'
    else
      render :new
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to admin_admins_path, notice: '管理者情報を更新しました'
    else
      render :edit
    end
  end

  def destroy
    begin
      @admin.destroy!
      redirect_to admin_admins_path, notice: '管理者を削除しました'
    rescue => e
      redirect_to admin_admins_path, error: e.message
    end
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:name, :email, :password, :password_confirmation, :role_ids)
  end
end
