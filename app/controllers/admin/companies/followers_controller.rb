class Admin::Companies::FollowersController < Admin::AdminController
  before_action :set_company

  def index
    @q = Company::Follower.includes(:user, :student)
           .where(company_id: @company.id)
           .ransack(params[:q])
    @followers = @q.result.page(params[:page]).per(100)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb '企業一覧', admin_companies_path
    add_breadcrumb @company.name, admin_company_path(@company)
    add_breadcrumb 'フォロワー一覧'
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end
end