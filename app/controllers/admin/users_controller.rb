class Admin::UsersController < Admin::AdminController
  load_and_authorize_resource except: [:really_destroy]
  before_action :set_user, only: [:edit, :update, :destroy]

  def index
    @q = User.includes(:roles, :profile, :student, :supporter, :orders, company: :projects).order('id DESC').ransack(params[:q])

    if params.has_key?(:q) && params[:q].has_key?(:s) && params[:q][:s].include?('roles_id')
      @users = @q.result.order('students.id desc').page(params[:page]).per(100)
    else
      @users = @q.result.page(params[:page]).per(100)
    end

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'ユーザー一覧'
  end

  def show
    @user = User.find(params[:id])
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'ユーザー一覧', admin_users_path
    add_breadcrumb @user.name
  end

  def edit
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'ユーザー一覧', admin_users_path
    add_breadcrumb @user.name, admin_user_path(@user)
    add_breadcrumb '編集'
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: 'ユーザーを更新しました'
    else
      add_breadcrumb 'ダッシュボード', admin_root_path
      add_breadcrumb 'ユーザー一覧', admin_users_path
      add_breadcrumb @user.name, admin_user_path(@user)
      add_breadcrumb '編集'
      render :edit
    end
  end

  def destroy
    name = @user.last_name
    email = @user.email
    @user.destroy
    UserMailer.leaved(name, email).deliver_now
    redirect_to admin_users_path, notice: 'ユーザーを削除しました'
  end

  def download
    users = User.includes(:roles, :profile, :student, :company).ransack(params[:q]).result(distinct: true)
    csv = User.to_csv(users)
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data bom + csv.encode(Encoding::UTF_8), type: 'text/csv'
  end

  def quits
    @q = User.only_deleted.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(100)
  end

  def really_destroy
    @user = User.only_deleted.find(params[:id])
    @user.really_destroy!
    redirect_to quits_admin_users_path, notice: '情報を抹消しました'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      profile_attributes: [:id, :name, :image, :receive_notification, :description]
    )
  end
end
