class Api::V1::ProjectsController < Api::V1::ApiController
  def index
    @projects = Project.all.order(:id)
    render json: @projects, callback: callback_param
  end

  def show
    @project = Project.find(params[:id])
  end

  private

  def callback_param
    params[:callback].present? ? params[:callback].gsub(/\W/, '') : nil
  end
end