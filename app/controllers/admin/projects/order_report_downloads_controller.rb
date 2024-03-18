class Admin::Projects::OrderReportDownloadsController < Admin::AdminController
  before_action :set_project

  def show
    download = OrderReportDownload.find(params[:id])
    redirect_to download.file.url
  end

  def new
    @download = OrderReportDownload.new
  end

  def create
    @download = OrderReportDownload.new(order_report_download_params)

    unless @download.save
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def order_report_download_params
    params.require(:order_report_download).permit(:admin_id, :project_id, :basis_start_on, :basis_end_on)
  end
end
