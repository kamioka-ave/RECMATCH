class Admin::Projects::OrderRecordDownloadsController < Admin::AdminController
  before_action :set_project

  def show
    download = OrderRecordDownload.find(params[:id])
    redirect_to download.file.url
  end

  def new
    @download = OrderRecordDownload.new(order_record_type: params[:type])
  end

  def create
    @download = OrderRecordDownload.new(order_record_download_params)

    unless @download.save
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def order_record_download_params
    params.require(:order_record_download).permit(:admin_id, :project_id, :basis_start_on, :basis_end_on, :order_record_type)
  end
end
