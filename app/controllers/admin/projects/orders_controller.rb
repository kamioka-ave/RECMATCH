class Admin::Projects::OrdersController < Admin::AdminController
  before_action :set_project

  def angel_downloads
    csv = @project.angel_downloads_csv
    bom = "\xEF\xBB\xBF".encode(Encoding::UTF_8)
    send_data bom + csv.encode(Encoding::UTF_8), type: 'text/csv'
  end

  def refund
    @order = NormalOrder.find(params[:id])
    @order.refund!
    redirect_to admin_project_path(@project), notice: '返金済にしました'
  rescue => e
    redirect_to admin_project_path(@project), error: e.message
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end