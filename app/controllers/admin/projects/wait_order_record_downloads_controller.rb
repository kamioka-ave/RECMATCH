class Admin::Projects::WaitOrderRecordDownloadsController < Admin::AdminController
  before_action :set_project

  def show
    download = WaitOrderRecordDownload.find(params[:id])
    redirect_to download.file.url
  end

  def new
    @download = WaitOrderRecordDownload.new(order_record_type: params[:type])
  end

  def create
    @download = WaitOrderRecordDownload.new(wait_order_record_download_params)

    unless @download.save
      render :new
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def wait_order_record_download_params
    params.require(:wait_order_record_download).permit(:admin_id, :project_id, :basis_start_on, :basis_end_on, :order_record_type)
  end
end
