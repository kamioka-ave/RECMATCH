class Admin::ExecutedProjectsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_executed_project, only: [:edit, :update, :destroy]

  def index
    @executed_projects = ExecutedProject.includes(:project).all.order(:rank)
  end

  def new
    @executed_project = ExecutedProject.new
  end

  def edit; end

  def create
    @executed_project = ExecutedProject.new(executed_project_params)

    if @executed_project.save
      redirect_to admin_executed_projects_path, notice: '成約したプロジェクトを登録しました'
    else
      render :new
    end
  end

  def update
    if @executed_project.update(executed_project_params)
      redirect_to admin_executed_projects_path, notice: '成約したプロジェクトを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @executed_project.destroy
    redirect_to admin_executed_projects_path, notice: '成約したプロジェクトを削除しました'
  end

  private

  def set_executed_project
    @executed_project = ExecutedProject.find(params[:id])
  end

  def executed_project_params
    params.require(:executed_project).permit(:project_id, :rank)
  end
end
