class Admin::Companies::FollowersEmailsController < Admin::AdminController
  before_action :set_company

  def new
    @email = Company::FollowersEmail.new
    add_common_breadcrumb
    add_breadcrumb 'メールの作成'
  end

  def confirm
    @email = Company::FollowersEmail.new(email_params)

    if @email.valid?
      add_common_breadcrumb
      add_breadcrumb '配信内容の確認'
    else
      add_common_breadcrumb
      add_breadcrumb 'メールの作成'
      render :new
    end
  end

  def create
    @email = Company::FollowersEmail.new(email_params)

    if @email.save
      redirect_to admin_company_followers_path(@company), notice: 'メールを配信しました'
    else
      add_common_breadcrumb
      add_breadcrumb 'メールの作成'
      render :new
    end
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def email_params
    params.require(:company_followers_email).permit(
      :company_id, :admin_id, :subject, :plain
    )
  end

  def add_common_breadcrumb
    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'フォロワー一覧', admin_company_followers_path(@company)
  end
end