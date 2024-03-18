class Admin::PickupProjectsController < Admin::AdminController
  load_and_authorize_resource
  before_action :set_pickup_project, only: [:edit, :update, :destroy]

  def index
    @pickup_projects = PickupProject.includes(:project).all.order(:rank)
  end

  def new
    @pickup_project = PickupProject.new
  end

  def edit; end

  def create
    @pickup_project = PickupProject.new(pickup_project_params)

    if @pickup_project.save
      redirect_to admin_pickup_projects_path, notice: 'ピップアッププロジェクトを登録しました'
    else
      render :new
    end
  end

  def update
    if @pickup_project.update(pickup_project_params)
      redirect_to admin_pickup_projects_path, notice: 'ピップアッププロジェクトを更新しました'
    else
      render :edit
    end
  end

  def destroy
    @pickup_project.destroy
    redirect_to admin_pickup_projects_path, notice: 'ピップアッププロジェクトを削除しました'
  end

  private

  def set_pickup_project
    @pickup_project = PickupProject.find(params[:id])
  end

  def pickup_project_params
    params.require(:pickup_project).permit(:project_id, :rank)
  end
end
