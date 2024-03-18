class Admin::Projects::CancelReasonsController < Admin::AdminController
  before_action :set_project

  def index
    order_ids = Order.where(project_id: @project.id).select('id')
    @q = CancelReason.where(order_id: order_ids).where.not(note: nil)

    add_breadcrumb 'ダッシュボード', admin_root_path
    add_breadcrumb 'プロジェクト一覧', admin_projects_path
    add_breadcrumb @project.name.truncate(30), admin_project_path(@project)
    add_breadcrumb 'キャンセル理由（その他）'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
